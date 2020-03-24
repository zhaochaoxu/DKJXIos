//
//  RYHomeTopViewCell.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/5/4.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYHomeTopViewCell.h"

@implementation RYHomeTopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel setFrame:self.contentView.bounds];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _titleLabel;
}


@end
