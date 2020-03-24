//
//  HBSpecialityCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/6/23.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBSpecialityCell.h"
#import <UIImageView+WebCache.h>

@interface HBSpecialityCell ()

@property (nonatomic, weak) UIImageView *titleImg;

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UILabel *addrL;

@property (nonatomic, weak) UILabel *dateL;

@property (nonatomic, weak) UIButton *commentBtn;

@end

@implementation HBSpecialityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *titleImg = [[UIImageView alloc] init];
        titleImg.image = [UIImage imageNamed:@"lang"];
        [self.contentView addSubview:titleImg];
        _titleImg = titleImg;
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"安格斯牛仔骨熬";
        titleL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:titleL];
        _titleL = titleL;
        
        UILabel *addrL = [[UILabel alloc] init];
        addrL.text = @"三清潭";
        addrL.textColor = [UIColor grayColor];
        addrL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:addrL];
        _addrL = addrL;
        
        UILabel *dateL = [[UILabel alloc] init];
        dateL.text = @"2018.11.27领取";
        dateL.font = [UIFont systemFontOfSize:13];
        dateL.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:dateL];
        _dateL = dateL;
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setTitle:@"立即点评" forState:UIControlStateNormal];
        [commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        commentBtn.backgroundColor = [UIColor yellowColor];
        [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:commentBtn];
        _commentBtn = commentBtn;
        
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(70);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImg.mas_right).offset(5);
            make.top.equalTo(titleImg);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
        [addrL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImg.mas_right).offset(5);
            make.top.equalTo(titleL.mas_bottom).offset(3);
            make.right.equalTo(self.contentView.mas_right).offset(-60);
            
        }];
        
        [dateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImg.mas_right).offset(5);
            make.bottom.equalTo(titleImg.mas_bottom);
        }];
        
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-5);
            make.centerY.equalTo(titleImg);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(30);
        }];
        
        
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    if ([dict objectForKey:@"img"]) {
        NSString *str = [NSString stringWithFormat:@"%@%@",RYServiceAddress,[dict objectForKey:@"img"]];
        [self.titleImg sd_setImageWithURL:[NSURL URLWithString:str]];
    }
    
    if ([dict objectForKey:@"dishName"]) {
        self.titleL.text = [dict objectForKey:@"dishName"];
    }
    
    if ([dict objectForKey:@"bussHubName"]) {
        self.addrL.text = [dict objectForKey:@"bussHubName"];
    }
    
    if ([dict objectForKey:@"date"]) {
        self.dateL.text = [dict objectForKey:@"date"];
    }
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
