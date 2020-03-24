//
//  HTSaveCachesFile.m
//  RisenbIOSClient
//
//  Created by 黄铁 on 14-5-27.
//  Copyright (c) 2014年 Risenb App Department With iOS. All rights reserved.
//

#import "HTSaveCachesFile.h"

@implementation HTSaveCachesFile

+ (id)loadDataList:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FolderName];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        NSError *error ;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
        }
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    //解归档
    return [NSKeyedUnarchiver unarchiveObjectWithFile:fileDirectory];
}

+ (void)saveDataList:(id)object fileName:(NSString *)fileName
{
    //归档对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FolderName];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        NSError *error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            
        }
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:fileDirectory];
    
    if (success)
    {
        NSLog(@"归档成功");
    }
    
}

+ (BOOL)removeFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:FolderName];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:path])
    {
        return YES;
    }
    
    NSString* fileDirectory = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",fileName]];
    
    BOOL success = [manager removeItemAtPath:fileDirectory error:nil];
    
    if (success)
    {
        NSLog(@"归档删除成功");
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
