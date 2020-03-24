//
//  HBView.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/7.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBView.h"

@interface HBView ()

@property (nonatomic, strong) UILabel *headlineL;
@property (nonatomic, strong) UIImageView *titleImg;

@end

@implementation HBView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        [self addSubview:self.headlineL];
        
    }
    return self;
    
}

- (UILabel *)headlineL {
    if (!_headlineL) {
        _headlineL = [[UILabel alloc] initWithFrame:CGRectZero];
        _headlineL.textAlignment = NSTextAlignmentCenter;
        _headlineL.textColor =  [UIColor grayColor];
        _headlineL.font = [UIFont systemFontOfSize:13.0];
    }
    return _headlineL;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
