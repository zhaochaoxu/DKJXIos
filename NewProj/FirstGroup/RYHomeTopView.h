//
//  RYHomeTopView.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/5/4.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYHomeTopView : UIView

@property (retain, nonatomic) NSArray <NSString *>*titles;

@property (assign, nonatomic) NSInteger currentIndex;

@property (copy, nonatomic) void (^didSelectedRowAtIndexPathHandler)(NSIndexPath *indexPath,NSString *value);

@end
