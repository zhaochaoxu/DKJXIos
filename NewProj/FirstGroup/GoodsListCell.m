//
//  GoodsListCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/8.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "GoodsListCell.h"
#import <Masonry.h>

@interface GoodsListCell ()

@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UIImageView *goodsImg;

@end

@implementation GoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *nameL = [[UILabel alloc] init];
//        nameL.backgroundColor = [UIColor cyanColor];
//        nameL.numberOfLines = 0;
//        nameL.text = @"12341234";
        nameL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:nameL];
        _nameL = nameL;
        
        UIImageView *goodsImg = [[UIImageView alloc] init];
//        goodsImg.backgroundColor = [UIColor cyanColor];
        goodsImg.layer.masksToBounds = YES;
        goodsImg.layer.cornerRadius = 5;
        [self.contentView addSubview:goodsImg];
        _goodsImg = goodsImg;
        
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.centerX.equalTo(self.contentView);
        }];
        
        [goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(90);
        }];
        
        
        
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    if ([dict objectForKey:@"title"]) {
        NSString *str = [dict objectForKey:@"title"];
        self.nameL.text = str;
    }
    if ([dict objectForKey:@"url"]){
        [self.goodsImg sd_setImageWithURL:[dict objectForKey:@"url"] placeholderImage:[UIImage imageNamed:@"加载中"]];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    [self.nameL removeFromSuperview];
//    [self.goodsImg removeFromSuperview];
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
