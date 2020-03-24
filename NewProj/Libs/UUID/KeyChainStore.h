//
//  KeyChainStore.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
