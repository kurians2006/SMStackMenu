//
//  SMMenuViewController.m
//  Stack Menu (with ECSlidingViewController)
//
//  Created by Samuel Scott Robbins on 6/4/14.
//
//

#import "SMMenuViewController.h"
#import "ECSlidingViewController.h"

@interface SMMenuViewController ()

@end

@implementation SMMenuViewController
@synthesize currentViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // All of these topItems will be displayed and all of them have views (shown in parentViewItems) to navigate to
    NSArray *topItems = [NSArray arrayWithObjects: @"Home", @"Parent 1", @"Press 2 Open", nil];
    NSArray *parentViewItems = [NSArray arrayWithObjects:@"Home", @"Parent 1", nil];
    
    NSMutableArray *subItems = [NSMutableArray new];
    //
    int currentExpandedIndex = -1;  // default for collapsed Menu

    // For EVERY parent item spot, create an array of sub items you wish to display in drop down ([NSNull null] as first object if no subitems
    // ex: NSMutableArray *homeSubs = [NSMutableArray arrayWithObjects:@"Example", @"Example", nil];
    // (make it have [NSNull null] if no subview exists)
    NSMutableArray *homeSubs = [NSMutableArray arrayWithObjects:[NSNull null], nil];
    NSMutableArray *parent1Subs = [NSMutableArray arrayWithObjects:@"Parent 2", nil];
    NSMutableArray *Press2OpenSubs = [NSMutableArray arrayWithObjects:@"Parent 3", nil];
    
    // Now add these array to subItems Array (make sure there is a value for those without submenus too
    [subItems addObject:homeSubs];
    [subItems addObject:parent1Subs];
    [subItems addObject:Press2OpenSubs];
    
    // How far over do you want the menu to slide
    [self.slidingViewController setAnchorRightRevealAmount:225.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    [self initializeViewControllerWithTopItems:topItems parentViewItems:parentViewItems subItems:subItems currentExpandedIndex:currentExpandedIndex];
    
    // move down 20f for iOS 7
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    // Notification to
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MovedToNewViewController:)
                                                 name:@"MovingToNewViewController"
                                               object:nil];
}

#pragma mark - Table view data source
-(void)MovedToNewViewController:(NSNotification *)dataDict
{
     currentViewController = [[dataDict userInfo] objectForKey:@"currentStoryboardId"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. (only one section, so numberofrows will return the correct amount)
    return [self numberOfRows];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create button's background images
    UIImage *expandButtonImage = [UIImage imageNamed:@"down_arrow.png"];
    UIImage *collapseButtonImage = [UIImage imageNamed:@"up_arrow.png"];

    // get cell from SMStackMenu
    UITableViewCell *cell;
    cell = [self returnCellForMenuWithIndexPath:indexPath
                          withExpandButtonImage:expandButtonImage
                        withCollapseButtonImage:collapseButtonImage
                                         sender:self
                                       withCell:cell];
    
    // Futher customize cell
    UIImageView *orangeColorView = [[UIImageView alloc] init];
    orangeColorView.image = [UIImage imageNamed:@"gradient.png"];
    orangeColorView.layer.masksToBounds = YES;
    
    cell.selectedBackgroundView = orangeColorView;
    
    return cell;
}

// This receives button clicked event from expandButton
-(void) buttonClicked:(id)sender
{
    [self expandTableOnClickByButton:sender tableView:self.tableView];
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do any other checks you want before this. You can manually move to the next storyboard by taking a look at how ECSlidingViewController changes
    
    // This will move to the view controller based on the STORYBOARD IDENTIFIER, which HAS to be the same as the text in the cell
    [self handleSelectedIndexPath:indexPath withTableView:self.tableView];
         
}



@end
