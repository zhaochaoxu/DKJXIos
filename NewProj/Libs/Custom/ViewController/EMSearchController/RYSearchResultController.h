//
//  RYSearchResultController.h
//  HRRongYaoApp
//
//  Created by 胡贝贝 on 2017/5/26.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYBaseViewController.h"

@interface RYSearchResultController : RYBaseViewController

@property (nonatomic, strong) NSMutableArray *displaySource;

@property (nonatomic) UITableViewCellEditingStyle editingStyle;

@property (copy) UITableViewCell * (^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) void (^didDeselectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy) NSInteger (^numberOfSectionsInTableViewCompletion)(UITableView *tableView);
@property (copy) NSInteger (^numberOfRowsInSectionCompletion)(UITableView *tableView, NSInteger section);

@end
