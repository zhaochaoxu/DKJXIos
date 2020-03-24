//
//  HBMineCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/5/21.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBMineCell.h"


@interface HBMineCell ()

@property (nonatomic, weak) UIImageView *titleImg;

@property (nonatomic, weak) UILabel *titleNameL;

@end

@implementation HBMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *titleImg = [[UIImageView alloc] init];
//        titleImg.backgroundColor = HBRedColor;
        titleImg.layer.masksToBounds = YES;
        titleImg.layer.cornerRadius = 5;
        [self.contentView addSubview:titleImg];
        _titleImg = titleImg;
        
        UILabel *titleNameL = [[UILabel alloc] init];
//        titleNameL.backgroundColor = [UIColor cyanColor];
        titleNameL.numberOfLines = 0;
        titleNameL.text = @"东北菜";
        titleNameL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:titleNameL];
        _titleNameL = titleNameL;
        
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(56/2);
            make.height.mas_equalTo(66/2);
        }];
        
        [titleNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImg.mas_right).offset(20);
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

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    if (dict) {
        self.titleImg.image = [UIImage imageNamed:[dict objectForKey:@"img"]];
        self.titleNameL.text = [dict objectForKey:@"name"];
    }
}

@end
