//
//  HBLeftTableViewCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/28.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBLeftTableViewCell.h"

@implementation HBLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"我我我";
//        titleL.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:titleL];
        _titleL = titleL;
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);

        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.titleL.textColor = HBRedColor;
//        self.contentView.backgroundColor = HBRedColor;
    } else {
        self.titleL.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
