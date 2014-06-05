//
//  SMStackMenuViewController.m
//  BookstoreApp
//
//  Created by Scott Robbins on 3/20/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//  Version: 1

#import "SMStackMenuViewController.h"
#import "ECSlidingViewController.h"

NSString *const SMStackMenuMovingToNewViewController    = @"MovingToNewViewController";

@interface SMStackMenuViewController ()

@end

@implementation SMStackMenuViewController

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTopView:) name:ECSlidingViewTopWillReset object:nil];
}

-(void)resetTopView:(id)selector
{
    if(_currentExpandedIndex > -1)
        [self collapseSubItemsAtIndex:_currentExpandedIndex inTableView:self.tableView];
}

-(void)initializeViewControllerWithTopItems: (NSArray *)topItems parentViewItems: (NSArray *)parentViewItems subItems: (NSMutableArray *)subItems currentExpandedIndex:(int)currentExpandedIndex
{
    _topItems  = topItems;
    _parentViewItems = parentViewItems;
    _subItems = subItems;
    _currentExpandedIndex = currentExpandedIndex;
    
    // set number of rows
    _numberOfRows = [topItems count];
}

-(int)numberOfRows {
    return _numberOfRows;
}

-(UITableViewCell *)returnCellForMenuWithIndexPath:(NSIndexPath *)indexPath  withExpandButtonImage:(UIImage *)expandButtonImage withCollapseButtonImage:(UIImage *)collapseButtonImage sender:(id)sender withCell:(UITableViewCell *)cell
{
    _expandButtonImage = expandButtonImage;
    _collapseButtonImage = collapseButtonImage;
    
    UITableViewController *menuViewController = (UITableViewController *)sender;
    UITableView *tableView = menuViewController.tableView;
    
    static NSString *ParentCellIdentifier = @"ParentCell";
	static NSString *ChildCellIdentifier = @"ChildCell";
    
	// check if it is a child
	BOOL isChild = [self isChild:indexPath.row];

	if (isChild){
		cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
	}
    
    // if cell doesn't exist, create and make parent
	if (cell==nil) {
		cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
	}
    
	// if child, make cell text = [[correct child array] insert it at the beginning]
	if (isChild){
		cell.textLabel.text = [[_subItems objectAtIndex:_currentExpandedIndex] objectAtIndex:indexPath.row - _currentExpandedIndex - 1];
        cell.indentationLevel = 2;
	} else {
        
		int topIndex;
        
        // if expanded, and cell is past expansion point, account for expanded subitems when setting the index path
		if ((_currentExpandedIndex > -1) && indexPath.row > _currentExpandedIndex)
			topIndex = indexPath.row - [[_subItems objectAtIndex:_currentExpandedIndex] count];
		else
			topIndex = indexPath.row;
        
		cell.textLabel.text = [_topItems objectAtIndex:topIndex];
		cell.detailTextLabel.text = @"";
        
        
        // Create button
        UIImage *expandButtonImage = _expandButtonImage;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:[indexPath row]];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside]; // ignore warning, "self" when I add the cell will be in a different view controller
        
        button.frame = CGRectMake(165, 0, cell.frame.size.width - 260, cell.frame.size.height);
        [button setImage:expandButtonImage forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeCenter];
        
		// Here we’re going to make the arrow button
		// Create expand button with click event
        // If the correct subitems array for corresponding parent has a non null value in it, make expand button
        if ([[_subItems objectAtIndex: indexPath.row] objectAtIndex:0] != [NSNull null])
            [cell.contentView addSubview:button]; // Add expandButton to table
        
	}
    return cell;
}

- (BOOL)isChild:(NSInteger)indexPath{
    
    BOOL isChild;
    
	// if something has been expanded, this index is greater than the expanded parent but less than the next parent
    if((_currentExpandedIndex > -1) && (indexPath > _currentExpandedIndex) && (indexPath <= _currentExpandedIndex + [[_subItems objectAtIndex:_currentExpandedIndex] count]))
        isChild = true;
    else
        isChild = false;
    
    return isChild;
}

-(void)expandTableOnClickByButton:(id)sender tableView:(UITableView *)tableView
{
    UIButton *expandButton = (UIButton *)sender;
    [tableView beginUpdates];
    
    BOOL shouldCollapse = false;
    
    // if the currently expanded Index is the same as this clicked, collapse and set expanded index to -1 (all collapsed)
    if (_currentExpandedIndex == expandButton.tag) {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentExpandedIndex inSection:0] animated:YES];
        [self collapseSubItemsAtIndex:_currentExpandedIndex inTableView:tableView];
        _currentExpandedIndex = -1;
    } else {
        if (_currentExpandedIndex > -1)
            shouldCollapse = true;
        
        if (shouldCollapse){
            [self collapseSubItemsAtIndex:_currentExpandedIndex inTableView:tableView];
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentExpandedIndex inSection:0] animated:YES];
        }
        [tableView endUpdates];
        [tableView beginUpdates];
        // if you should collapse and the index path is greater than parent currentExpandedIndex = parent, otherwise current index
        _currentExpandedIndex = expandButton.tag;
        
        [self expandItemAtIndex:_currentExpandedIndex inTableView:tableView];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentExpandedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

    }
    
    [tableView endUpdates];

}

- (void)expandItemAtIndex:(int)index inTableView:(UITableView *)tableView {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [_subItems objectAtIndex:index];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:path];
    
    int insertPos = index + 1;
    
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos inSection:0]];
        insertPos++;
        _numberOfRows++;
    }
    
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    // Change button image to up arrow for collapsing
    for(id view in [cell.contentView subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = view;
            [btn setImage:_collapseButtonImage forState:UIControlStateNormal];
        }
    }
}

-(void)collapseSubItemsAtIndex:(int)index inTableView:(UITableView *)tableView {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:path];
    
    for (int i = index + 1; i <= index + [[_subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        _numberOfRows--;
        _currentExpandedIndex = -1;
    }
    
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    // Change button image to down arrow for expanding
    for(id view in [cell.contentView subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = view;
            [btn setImage:_expandButtonImage forState:UIControlStateNormal];
        }
    }
}

-(void)handleSelectedIndexPath: (NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    UIViewController *newTopViewController;
    NSString *identifier;
    int collapseDifference=0;
    int expandedIndex = _currentExpandedIndex;
    BOOL shouldCollapse = false;
    
    // check if it is a child
	BOOL isChild = [self isChild:indexPath.row];
    
    
    // Collapse before changing views if needed
    if (_currentExpandedIndex > -1)
        shouldCollapse = true;
    
    if (shouldCollapse){
        // set collapse difference to amount of children collapsed only if new view's index will be changed (greater than currently expanded)
        if (indexPath.row > _currentExpandedIndex)
            collapseDifference = [[_subItems objectAtIndex:_currentExpandedIndex] count];
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentExpandedIndex inSection:0] animated:YES];
        [self collapseSubItemsAtIndex:_currentExpandedIndex inTableView:tableView];
    }
    
    // changes the identifier to correct placement in designated array (remember subItems is an array of arrays, topItems isn't)
    // This works because only one droor can be open at a time
    if(isChild){
        identifier = [NSString stringWithFormat:@"%@", [[_subItems objectAtIndex:expandedIndex] objectAtIndex:indexPath.row - expandedIndex - 1]];
    } else {
        identifier = [NSString stringWithFormat:@"%@", [_topItems objectAtIndex:indexPath.row - collapseDifference]];
    }
    
    // Essentially, check to see if you have specified there is a view to go with this identifier
    if([_parentViewItems containsObject:identifier] || isChild)
    {
        // move to new view
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        // ECANCELED prevents it from bouncing on the switch, otherwise ECRight should be listed
        [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
            if (_currentExpandedIndex > -1)
                [self collapseSubItemsAtIndex:_currentExpandedIndex inTableView:tableView];
            
            NSDictionary *dataDict = [NSDictionary dictionaryWithObject:identifier forKey:@"currentStoryboardId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SMStackMenuMovingToNewViewController object:self userInfo:dataDict];
        }];
    }
    else if(expandedIndex != indexPath.row)    // Already collapsed at this point, by now you have left to the correct view controller or need to expand (but don't expand if expanded previously)
    {
        _currentExpandedIndex = indexPath.row - collapseDifference;
        [self expandItemAtIndex:_currentExpandedIndex inTableView:tableView];
    }
}



@end
