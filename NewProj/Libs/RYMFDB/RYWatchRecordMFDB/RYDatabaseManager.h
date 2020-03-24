//
//  RYDatabaseManager.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYDatabaseManagerModel.h"

@interface RYDatabaseManager : NSObject

//单例
+ (RYDatabaseManager *)sharedManager;


//插入数据
- (void)insertUser:(RYDatabaseManagerModel *)model;

//查询数据
- (NSArray *)getAllDatas;

//删除数据
- (BOOL)deleteUser:(RYDatabaseManagerModel *)model;

//更新数据
- (void)updateUser:(RYDatabaseManagerModel *)model;

@end
