//
//  HBStoryListCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/20.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBStoryListCell.h"

@interface HBStoryListCell ()

@property (nonatomic, weak) UILabel *titleL;

@property (nonatomic, weak) UILabel *storyL;


@end

@implementation HBStoryListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.font = [UIFont systemFontOfSize:14.0];
        
//        titleL.text = @"你的发发";
        titleL.numberOfLines = 0;
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL];
        _titleL = titleL;
        

        UILabel *storyL = [[UILabel alloc] init];
        storyL.numberOfLines = 0;
//        storyL.text = @"你的发发付首付水电费水电费水电费水电费水电费水电费水电费水电费水电费是的辅导费";
        storyL.textAlignment = NSTextAlignmentCenter;
        storyL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:storyL];
        _storyL = storyL;
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [storyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleL.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        
        
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    if ([dict objectForKey:@"title"]) {
        
        NSString *str = [dict objectForKey:@"title"];

        self.titleL.text = str;
    }
    if ([dict objectForKey:@"story"]){
        NSString *str = [dict objectForKey:@"story"];
        NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSString *strUrl1 = [strUrl stringByReplacingOccurrencesOfString:@"n" withString:@""];
        NSString *strUrl2 = [strUrl1 stringByReplacingOccurrencesOfString:@"\\" withString:@""] ;

        self.storyL.text = strUrl2;
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
