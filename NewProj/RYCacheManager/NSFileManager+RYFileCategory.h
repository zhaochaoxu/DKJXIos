//
//  NSFileManager+RYFileCategory.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/14.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (RYFileCategory)

/**
 *  @brief  Documents路径
 */
- (NSString *)documents;

/**
 *  @brief  下载的图片文件路径
 */
- (NSString *)fileDocuments;

/**
 *  @brief  下载的视频文件路径
 */
- (NSString *)videoDocuments;

/**
 *  @brief  获取文件大小.单位B.
 */
- (int64_t)bytesWithFilePath:(NSString *)filePath;

/**
 *  @brief  下载文件夹名称
 */
- (NSString *)downloadFilePath;

/**
 *  @brief  删除指定的下载文件
 */
- (BOOL)deleteDownFileWithName:(NSString *)fileName;

/**
 *  @brief  删除所有下载文件
 */
- (BOOL)deleteAllDownloadFile;

/**
 *  @brief  缓存文件夹名称
 */
- (NSString *)cacheFilePath;

/**
 *  @brief  获取指定的缓存文件
 */
- (NSData *)dataAtCacheFileWithName:(NSString *)fileName;

/**
 *  @brief  删除指定的缓存文件
 */
- (BOOL)deleteCacheFileWithName:(NSString *)fileName;

/**
 *  @brief  删除所有缓存文件
 */
- (BOOL)deleteAllCacheFile;

@end
