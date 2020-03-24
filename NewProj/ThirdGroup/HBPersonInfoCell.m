//
//  HBPersonInfoCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/24.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBPersonInfoCell.h"

@interface HBPersonInfoCell ()



@end

@implementation HBPersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"头像";
        titleL.numberOfLines = 0;
        [self.contentView addSubview:titleL];
        _titleL = titleL;
        
        UILabel *subTitleL = [[UILabel alloc] init];
        subTitleL.text = @"hide on bush";
        subTitleL.numberOfLines = 0;
        [self.contentView addSubview:subTitleL];
        _subTitleL = subTitleL;
        
        UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        imgBtn.userInteractionEnabled = NO;
        imgBtn.backgroundColor = HBRedColor;
        imgBtn.hidden = YES;
        imgBtn.layer.cornerRadius = 30;
        imgBtn.layer.masksToBounds = YES;
        [imgBtn setImage:[UIImage imageNamed:@"ka"] forState:UIControlStateNormal];
//        [imgBtn setImage:[UIImage imageNamed:@"lang"] forState:UIControlStateNormal];
//        [imgBtn setTitle:@"头像" forState:UIControlStateNormal];

        [self.contentView addSubview:imgBtn];
        _imgBtn = imgBtn;
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        
        [subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        
        [imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
        }];
        
    }
    return self;
}

//- (void)imgClick:(UIButton *)sender {

//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
