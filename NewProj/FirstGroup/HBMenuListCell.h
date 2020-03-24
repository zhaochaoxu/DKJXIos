//
//  HBMenuListCell.h
//  NewProj
//
//  Created by 胡贝 on 2019/4/5.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBMenuListCellDelegate <NSObject>

- (void)HBMenuListCellDelegate:(NSString *)number boolValue:(BOOL )value indexpath:(NSString *)num;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HBMenuListCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, weak) id<HBMenuListCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *num;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, weak) UIButton *loveCollectBtn;

- (void)setImageViewRed;

- (void)setImageViewGray;

@end

NS_ASSUME_NONNULL_END
