//
//  SMHomeViewController.m
//  Stack Menu (with ECSlidingViewController)
//
//  Created by Samuel Scott Robbins on 6/4/14.
//
//

#import "SMHomeViewController.h"
#import "SMMenuViewController.h"
#import "ECSlidingViewController.h"

@interface SMHomeViewController ()

@end

@implementation SMHomeViewController
@synthesize menuBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[SMMenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.tag = 0;
    menuBtn.frame = CGRectMake(0, 0, 70, 70);
    [menuBtn setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    [menuBtn setImageEdgeInsets:(UIEdgeInsetsMake(25, 10, 5, 25))];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuBtn];

}

// Required for ECSlidingViewController
-(IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
