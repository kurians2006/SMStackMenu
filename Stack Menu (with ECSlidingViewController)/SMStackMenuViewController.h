//
//  SMStackMenuViewController.h
//  BookstoreApp
//
//  Created by Scott Robbins on 3/20/14.
//  Copyright (c) 2014 Scott Robbins. All rights reserved.
//  Vesion: 1

@interface SMStackMenuViewController : UITableViewController

/** Notification that gets posted when the underRight view will appear */
extern NSString *const SMStackMenuMovingToNewViewController;

@property (strong,nonatomic) NSArray *parentViewItems;
@property (strong, nonatomic) NSArray *topItems;
@property (strong, nonatomic) NSMutableArray *subItems;
@property (nonatomic, assign) int currentExpandedIndex;
@property (nonatomic, assign) int numberOfRows;
@property (nonatomic, strong)UIImage *expandButtonImage;
@property (nonatomic, strong)UIImage *collapseButtonImage;

-(void)initializeViewControllerWithTopItems: (NSArray *)topItems parentViewItems: (NSArray *)parentViewItems subItems: (NSMutableArray *)subItems currentExpandedIndex:(int)currentExpandedIndex;
-(int)numberOfRows;
-(UITableViewCell *)returnCellForMenuWithIndexPath:(NSIndexPath *)indexPath withExpandButtonImage:(UIImage *)expandButtonImage withCollapseButtonImage:(UIImage *)collapseButtonImage sender:(id)sender withCell:(UITableViewCell *)cell;
-(void)expandTableOnClickByButton:(id)sender tableView:(UITableView *)tableView;
-(void)handleSelectedIndexPath: (NSIndexPath *)indexPath withTableView:(UITableView *)tableView;
-(void)collapseSubItemsAtIndex:(int)index inTableView:(UITableView *)tableView;

@end

@protocol neededMethods <NSObject>

-(void) buttonClicked:(id)sender;

@end
