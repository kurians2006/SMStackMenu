//
//  SMInitViewController.m
//  Stack Menu (with ECSlidingViewController)
//
//  Created by Samuel Scott Robbins on 6/4/14.
//
//

#import "SMInitViewController.h"

@interface SMInitViewController ()

@end

@implementation SMInitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
}

@end
