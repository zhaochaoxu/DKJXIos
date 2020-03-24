//
//  HBGoodsListController.h
//  NewProj
//
//  Created by 胡贝 on 2019/3/7.
//  Copyright © 2019年 胡贝. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol HBGoodsListControllerDeleagte <NSObject>

//代理传值

- (void)HBGoodsListControllerDeleagteWithValue:(NSString *)value;

@end


@interface HBGoodsListController : UIViewController

@property (nonatomic, strong) NSMutableArray *goodslist;

@property (nonatomic, strong) NSDictionary *imgDict;

@property (nonatomic, weak) id <HBGoodsListControllerDeleagte> delegate;


@end

