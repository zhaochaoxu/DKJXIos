//
//  XYRunTimeManager.h
//  Risenb
//
//  Created by fabs on 2017/1/4.
//  Copyright © 2017年 Risenb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYRunTimeManager : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)shareInstance;

- (void)startRunTimeWithTimeInterval:(NSTimeInterval)timeInterval
                       eventHandler:(void(^)(NSNumber *timeInterval))eventHandler
                         completion:(void(^)())completion;

- (void)cancleRunTime;

@end
