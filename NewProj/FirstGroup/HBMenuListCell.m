//
//  HBMenuListCell.m
//  NewProj
//
//  Created by 胡贝 on 2019/4/5.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBMenuListCell.h"
#import <Masonry.h>


@interface HBMenuListCell ()
{
    BOOL _isSeleted;
}

@property (nonatomic, weak) UIImageView *specialtyImg;//招牌菜
@property (nonatomic, weak) UILabel *specialtyNameL;//招牌菜名字
@property (nonatomic, weak) UILabel *restaurantPriceL;//餐厅价
@property (nonatomic, weak) UIImageView *courseImg;//一道菜的大图
@property (nonatomic, weak) UIImageView *smallCourseLogo;//一道菜的小图
@property (nonatomic, weak) UILabel *smallCourseLogoNameL;//一道菜f小图name

@property (nonatomic, weak) UIImageView *loveCollectImg;//一道菜收藏
@property (nonatomic, weak) UILabel *smallCourseDetailL;// 五道口地址
@property (nonatomic, weak) UILabel *remarksL;//备注


@property (nonatomic, weak) UILabel *nameL;
@property (nonatomic, weak) UIImageView *goodsImg;

//@property (nonatomic, weak) UIButton *loveCollectBtn;


@end

@implementation HBMenuListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *specialtyImg = [[UIImageView alloc] init];
//        specialtyImg.backgroundColor = [UIColor cyanColor];
        specialtyImg.layer.masksToBounds = YES;
        specialtyImg.image = [UIImage imageNamed:@"mark_signboard"];
        specialtyImg.layer.cornerRadius = 5;
        [self.contentView addSubview:specialtyImg];
        _specialtyImg = specialtyImg;

        
        UILabel *specialtyNameL = [[UILabel alloc] init];
//        specialtyNameL.backgroundColor = [UIColor cyanColor];
        specialtyNameL.numberOfLines = 0;
        specialtyNameL.text = @"东北菜";
        specialtyNameL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:specialtyNameL];
        _specialtyNameL = specialtyNameL;
        
        
        UILabel *restaurantPriceL = [[UILabel alloc] init];
        restaurantPriceL.textColor = [UIColor grayColor];
//        restaurantPriceL.backgroundColor = [UIColor cyanColor];
        restaurantPriceL.numberOfLines = 0;
        restaurantPriceL.text = @"餐厅售价：¥22.0";
        restaurantPriceL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:restaurantPriceL];
        _restaurantPriceL = restaurantPriceL;
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor grayColor];
        [restaurantPriceL addSubview:line];

        UIImageView *courseImg = [[UIImageView alloc] init];
//        courseImg.backgroundColor = [UIColor cyanColor];
        courseImg.layer.masksToBounds = YES;
//        courseImg.image = [UIImage imageNamed:@"lang"];
        courseImg.layer.cornerRadius = 5;
        [self.contentView addSubview:courseImg];
        _courseImg = courseImg;
        
        UIImageView *discountImg = [[UIImageView alloc] init];
        discountImg.image = [UIImage imageNamed:@"mark_discounts"];
        [self.contentView addSubview:discountImg];
        
        //小logo
        UIImageView *smallCourseLogo = [[UIImageView alloc] init];
//        smallCourseLogo.backgroundColor = [UIColor cyanColor];
        smallCourseLogo.image = [UIImage imageNamed:@"icon_merchant"];
        smallCourseLogo.layer.masksToBounds = YES;
        smallCourseLogo.layer.cornerRadius = 5;
        [self.contentView addSubview:smallCourseLogo];
        _smallCourseLogo = smallCourseLogo;
        
        //小图logo名字
        UILabel *smallCourseLogoNameL = [[UILabel alloc] init];
//        smallCourseLogoNameL.backgroundColor = [UIColor cyanColor];
        smallCourseLogoNameL.numberOfLines = 0;
        smallCourseLogoNameL.text = @"尖椒鸡蛋";
        smallCourseLogoNameL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:smallCourseLogoNameL];
        _smallCourseLogoNameL = smallCourseLogoNameL;
        
        //收藏
//        UIImageView *loveCollectImg = [[UIImageView alloc] init];
////        loveCollectImg.backgroundColor = [UIColor cyanColor];
//        loveCollectImg.layer.masksToBounds = YES;
//        loveCollectImg.image = [UIImage imageNamed:@"ic_heart_gray"];
//        loveCollectImg.layer.cornerRadius = 5;
//        [self.contentView addSubview:loveCollectImg];
//        _loveCollectImg = loveCollectImg;
        
        _isSeleted = NO;
        UIButton *loveCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        loveCollectBtn.backgroundColor = [UIColor lightGrayColor];
        [loveCollectBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_gray"] forState:UIControlStateNormal];
        [loveCollectBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_red"] forState:UIControlStateSelected];
        [loveCollectBtn addTarget:self action:@selector(loveCollectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:loveCollectBtn];
        _loveCollectBtn = loveCollectBtn;
        

        UILabel *smallCourseDetailL = [[UILabel alloc] init];
//        smallCourseDetailL.backgroundColor = [UIColor cyanColor];
        smallCourseDetailL.numberOfLines = 0;
        smallCourseDetailL.text = @"东北菜|五道口|3.50km";
        smallCourseDetailL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:smallCourseDetailL];
        _smallCourseDetailL = smallCourseDetailL;
        
        UILabel *remarksL = [[UILabel alloc] init];
//        remarksL.backgroundColor = [UIColor cyanColor];
        remarksL.numberOfLines = 1;
        remarksL.text = @"会更好的规范化";
        remarksL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:remarksL];
        _remarksL = remarksL;
        
        UILabel *cellLine = [[UILabel alloc] init];
        cellLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:cellLine];
        
        
        [specialtyImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(16);
        }];
        
        
        [specialtyNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(105);
            make.top.equalTo(self.contentView).offset(15);
        }];
        
        [restaurantPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(specialtyImg.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(20);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(restaurantPriceL).offset(75);
            make.right.equalTo(restaurantPriceL.mas_right);
            make.centerY.equalTo(restaurantPriceL);
            make.height.mas_equalTo(1);
        }];
        
        [courseImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(restaurantPriceL.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(200);
        }];
        
        [discountImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(courseImg).offset(35);
            make.right.equalTo(self.contentView.mas_right).offset(-13);
            make.width.mas_equalTo(216/2.5);
            make.height.mas_equalTo(82/2.5);

        }];
        
        [smallCourseLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(courseImg.mas_bottom).offset(10);
            make.left.equalTo(courseImg);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
        [smallCourseLogoNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(courseImg.mas_bottom).offset(10);
            make.left.equalTo(smallCourseLogo.mas_right).offset(20);
        }];
        
        [loveCollectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(courseImg.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-30);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [smallCourseDetailL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallCourseLogoNameL.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(20);
        }];
        
        [remarksL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(smallCourseDetailL.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)setImageViewRed {
    [self.loveCollectBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_red"] forState:UIControlStateSelected];
    self.loveCollectBtn.selected = YES;
}

- (void)setImageViewGray {
    [self.loveCollectBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_gray"] forState:UIControlStateSelected];
    self.loveCollectBtn.selected = NO;

}

- (void)loveCollectClick:(UIButton *)sender {
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    if (userid == nil) {
        [self.contentView makeToast:@"请登录"];
        return ;
    }
    
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        [self.loveCollectBtn setBackgroundImage:[UIImage imageNamed:@"ic_heart_red"] forState:UIControlStateSelected];

    }
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(HBMenuListCellDelegate:boolValue:indexpath:)]) {
        [self.delegate HBMenuListCellDelegate:@"1" boolValue:_isSeleted indexpath:self.num];
    }
    
    
    
}

- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    if (dict) {
        
        self.specialtyNameL.text = [dict objectForKey:@"dishName"];//菜系
        if (![[dict objectForKey:@"dishName"]isEqual:@""]) {
            //小菜
            self.smallCourseLogoNameL.text = [dict objectForKey:@"merchName"];
            
        }else{
            self.smallCourseLogoNameL.text = @"尖椒鸡蛋";
        }
        
        if ([dict objectForKey:@"img"]) {
            NSString *url = [NSString stringWithFormat:@"%@%@",RYServiceAddress,[dict objectForKey:@"img"]];
//            [self.courseImg sd_setImageWithURL:[NSURL URLWithString:url]];
            [self.courseImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ka"]];
        }

        
        
        if ([dict objectForKey:@"bussHubName"]) {
            
            double distanceNum = [[dict objectForKey:@"iosDistance"] doubleValue];
            if (distanceNum >1000.0) {
                double bigDistanceNum = distanceNum/1000;
                self.smallCourseDetailL.text = [NSString stringWithFormat:@"%@|%@|%.1fkm",[dict objectForKey:@"cuisineTypeName"],[dict objectForKey:@"bussHubName"],bigDistanceNum];
//                NSLog(@"%.2f",bigdistance);
            }else if(distanceNum<1000.0 && distanceNum>500.0){
                self.smallCourseDetailL.text = [NSString stringWithFormat:@"%@|%@|%@",[dict objectForKey:@"cuisineTypeName"],[dict objectForKey:@"bussHubName"],@"<1000m"];
               
            }else if(distanceNum<500.0  && distanceNum>100.0){
                self.smallCourseDetailL.text = [NSString stringWithFormat:@"%@|%@|%@",[dict objectForKey:@"cuisineTypeName"],[dict objectForKey:@"bussHubName"],@"<500m"];

            }else if (distanceNum<100.0){
                self.smallCourseDetailL.text = [NSString stringWithFormat:@"%@|%@|%@",[dict objectForKey:@"cuisineTypeName"],[dict objectForKey:@"bussHubName"],@"<100m"];

            }

            
        }
        if ([dict objectForKey:@"description"]) {
            self.remarksL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
        }
        
        NSNumber *boolNum = [dict objectForKey:@"collect"];
        BOOL collect = [boolNum boolValue];
        if (collect == YES) {
            [self setImageViewRed];
        }else{
            [self setImageViewGray];
        }
        
        
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
