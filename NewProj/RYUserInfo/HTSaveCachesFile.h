//
//  HTSaveCachesFile.h
//  RisenbIOSClient
//
//  Created by 黄铁 on 14-5-27.
//  Copyright (c) 2014年 Risenb App Department With iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FolderName @"RYUser"

@interface HTSaveCachesFile : NSObject

/**
 *  解归档
 *
 *  @param fileName 文件名
 *
 *  @return 解完归档后的数据
 */
+ (id)loadDataList:(NSString *)fileName;

/**
 *  归档
 *
 *  @param object   归档的数据
 *  @param fileName 文件名
 */
+ (void)saveDataList:(id)object fileName:(NSString *)fileName;

/**
 *  删除归档
 *
 *  @param fileName 文件名
 */
+ (BOOL)removeFile:(NSString *)fileName;

@end
