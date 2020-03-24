//
//  RYCacheManager.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYVideoModel.h"

@interface RYCacheManager : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)shareInstance;

/**
 *  @brief  获取所有搜索记录
 */
- (NSArray <NSString *>*)allSearchWorldList;

/**
 *  @brief  缓存搜索记录
 */
- (BOOL)saveSearchWorld:(NSString *)searchWorld;

/**
 *  @brief  删除搜索记录
 */
- (BOOL)removeAllSearchCache;

#pragma mark - RYCacheVideoModel Methods
/**
 *  @brief  获取全部缓存视频列表
 */
- (NSArray <RYVideoModel *>*)allVideoCacheModels;

/**
 *  @brief  保存缓存视频
 */
- (BOOL)saveVideoCacheModel:(RYVideoModel *)model;

/**
 *  @brief  删除指定的缓存视频
 */
- (BOOL)removeVideoCacheModel:(RYVideoModel *)model;

/**
 *  @brief  删除所有的缓存视频
 */
- (BOOL)removeAllVideoCacheModel;
#pragma mark -

#pragma mark - RYDownVideoModel Methods
/**
 *  @brief  获取所有下载完成的视频
 */
- (NSArray <RYVideoModel *>*)allDownVideoModels;

/**
 *  @brief  保存下载完成的视频
 */
- (BOOL)saveDownVideoModel:(RYVideoModel *)model;

/**
 *  @brief  从下载完成中删除指定的视频
 */
- (BOOL)removeDownVideModel:(RYVideoModel *)model;

/**
 *  @brief  删除所有下载完成的视频
 */
- (BOOL)removeAllDownVideoModel;
#pragma mark -
@end

