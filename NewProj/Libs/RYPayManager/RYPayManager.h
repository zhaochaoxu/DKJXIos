//
//  RYPayManager.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/11.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RYPaySuccessItem;

@interface RYPayManager : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)shareInstance;

- (void)startPayWithOrderInfo:(NSDictionary *)orderInfo
                      payType:(RYPayType)payType
                      success:(void(^)(RYPaySuccessItem *item))success
                       failer:(void(^)(NSString *errorMessage))failer
                     callBack:(void(^)(NSDictionary *result))callBack;

@end


@interface RYPaySuccessItem : NSObject

@end
