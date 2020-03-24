//
//  RYSegmentView.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/27.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYSegmentView;
@protocol RYSegmentViewDelegate <NSObject>

- (void)segementView:(RYSegmentView *)segmentView didSeletcedIndex:(NSInteger)index;

@end

@interface RYSegmentView : UIView

@property (assign, nonatomic) BOOL scale;

@property (copy, nonatomic) NSArray <NSString *>*titles;

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) id<RYSegmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles;

@end
