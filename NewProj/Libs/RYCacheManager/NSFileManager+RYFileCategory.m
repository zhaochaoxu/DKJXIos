//
//  NSFileManager+RYFileCategory.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/14.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "NSFileManager+RYFileCategory.h"

static NSString * const NSFileManager_DownloadFileName = @"NSFileManager_DownloadFileName";
static NSString * const NSFIleManager_CahceFileName = @"NSFIleManager_CahceFileName";

@implementation NSFileManager (RYFileCategory)

- (NSString *)documents {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (NSString *)fileDocuments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath= [NSString stringWithFormat:@"%@/Documents/fileDocuments",NSHomeDirectory()];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"fileDocuments"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",filePath);
    }
    return filePath;

}

- (NSString *)videoDocuments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath= [NSString stringWithFormat:@"%@/Documents/videoDocuments",NSHomeDirectory()];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"videoDocuments"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",filePath);
    }
    return filePath;
    
}

- (int64_t)bytesWithFilePath:(NSString *)filePath {
    return [[NSData alloc] initWithContentsOfFile:filePath].length;
}

- (NSString *)downloadFilePath {
    NSString *filePath = [[self documents] stringByAppendingPathComponent:NSFileManager_DownloadFileName];
    if (![self fileExistsAtPath:filePath]) {
        [self createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

- (BOOL)deleteDownFileWithName:(NSString *)fileName {
    NSString *filePath = [[self downloadFilePath] stringByAppendingPathComponent:fileName];
    return [self removeItemAtPath:filePath error:nil];
}

- (BOOL)deleteAllDownloadFile {
    return [self removeItemAtPath:[self downloadFilePath] error:nil];
}

- (NSString *)cacheFilePath {
    NSString *filePath = [[self documents] stringByAppendingPathComponent:NSFIleManager_CahceFileName];
    NSLog(@"filePath = %@",filePath);
    if (![self fileExistsAtPath:filePath]) {
        [self createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

- (NSData *)dataAtCacheFileWithName:(NSString *)fileName {
    NSString *filePath = [[self cacheFilePath] stringByAppendingPathComponent:fileName];
    return [[NSData alloc] initWithContentsOfFile:filePath];
}

- (BOOL)deleteCacheFileWithName:(NSString *)fileName {
    NSString *filePath = [[self cacheFilePath] stringByAppendingPathComponent:fileName];
    return [self removeItemAtPath:filePath error:nil];
}

- (BOOL)deleteAllCacheFile {
    return [self removeItemAtPath:[self cacheFilePath] error:nil];
}

@end
