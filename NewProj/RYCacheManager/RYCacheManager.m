//
//  RYCacheManager.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYCacheManager.h"

static NSString *const RYCacheManager_SearchWorld_Key = @"com.fabs_searchWorld";
static NSString *const RYCacheManager_CacheVideo_Key = @"RYCacheManager_CacheVideo_Key";
static NSString *const RYCacheManager_DownVideo_Key = @"RYCacheManager_DownVideo_Key";

@interface RYCacheManager ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation RYCacheManager

+ (instancetype)shareInstance {
    static RYCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}

- (NSArray<NSString *> *)allSearchWorldList {
    return [[self searchWorldList] reverseObjectEnumerator].allObjects;
}

- (BOOL)saveSearchWorld:(NSString *)searchWorld {
    NSMutableArray <NSString *>*list = [self searchWorldList];
    if ([list containsObject:searchWorld]) {
        [list removeObject:searchWorld];
    }
    [list addObject:searchWorld];
    [self.userDefaults setObject:list forKey:RYCacheManager_SearchWorld_Key];
    return [self.userDefaults synchronize];
}

- (BOOL)removeAllSearchCache {
    [self.userDefaults setObject:@[] forKey:RYCacheManager_SearchWorld_Key];
    return [self.userDefaults synchronize];
}

- (NSMutableArray <NSString *>*)searchWorldList {
    NSArray *list = [self.userDefaults objectForKey:RYCacheManager_SearchWorld_Key];
    if (!list) {
        return [[NSMutableArray alloc] init];
    }
    if (list.count > 15) {
        return [[list subarrayWithRange:NSMakeRange(0, 15)] mutableCopy];
    }
    return [list mutableCopy];
}


- (NSArray<RYVideoModel *> *)allVideoCacheModels {
    NSMutableArray <RYVideoModel *>*list = [[NSMutableArray alloc] init];
    [[self cacheModels] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RYVideoModel *model = [[RYVideoModel alloc] initWithString:obj error:nil];
        if (model) {
            [list addObject:model];
        }
    }];
    return list;
}

- (BOOL)saveVideoCacheModel:(RYVideoModel *)model {
    NSMutableArray <NSString *>*list = [self cacheModels];
    NSString *modelString = [model toJSONString];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RYVideoModel *sModel = [[RYVideoModel alloc] initWithString:obj error:nil];
        if (sModel && [sModel.url isEqualToString:model.url]) {
            [list replaceObjectAtIndex:idx withObject:modelString];
            *stop = YES;
        }
    }];
    if (![list containsObject:modelString]) {
        [list addObject:modelString];
    }
    [list addObject:[model toJSONString]];
    [self.userDefaults setObject:list forKey:RYCacheManager_CacheVideo_Key];
    return [self.userDefaults synchronize];
}

- (BOOL)removeVideoCacheModel:(RYVideoModel *)model {
    NSMutableArray <NSString *>*list = [self cacheModels];
    NSString *modelString = [model toJSONString];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:modelString]) {
            [list removeObject:obj];
            [self.fileManager deleteCacheFileWithName:model.fileName];
        }
    }];
    [self.userDefaults setObject:list forKey:RYCacheManager_CacheVideo_Key];
    return [self.userDefaults synchronize];
}

- (BOOL)removeAllVideoCacheModel {
    [self.userDefaults setObject:@[] forKey:RYCacheManager_CacheVideo_Key];
    [self.fileManager deleteAllCacheFile];
    return [self.userDefaults synchronize];
}

- (NSMutableArray <NSString *>*)cacheModels {
    NSArray <NSString *>* list = [self.userDefaults objectForKey:RYCacheManager_CacheVideo_Key];
    if (list) {
        return [list mutableCopy];
    }
    return [[NSMutableArray alloc] init];
}

- (NSArray<RYVideoModel *> *)allDownVideoModels {
    NSMutableArray <RYVideoModel *>*list = [[NSMutableArray alloc] init];
    [[self downModels] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RYVideoModel *model = [[RYVideoModel alloc] initWithString:obj error:nil];
        if (model) {
            [list addObject:model];
        }
    }];
    return list;
}

- (BOOL)saveDownVideoModel:(RYVideoModel *)model {
    NSMutableArray <NSString *>*list = [self downModels];
    NSString *modelString = [model toJSONString];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RYVideoModel *sModel = [[RYVideoModel alloc] initWithString:obj error:nil];
        if (sModel && [sModel.url isEqualToString:model.url]) {
            [list replaceObjectAtIndex:idx withObject:modelString];
            *stop = YES;
        }
    }];
    if (![list containsObject:modelString]) {
        [list addObject:modelString];
    }
    [self.userDefaults setObject:list forKey:RYCacheManager_DownVideo_Key];
    return [self.userDefaults synchronize];
}

- (BOOL)removeDownVideModel:(RYVideoModel *)model {
    NSMutableArray <NSString *>*list = [self downModels];
    NSString *modelString = [model toJSONString];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:modelString]) {
            [list removeObject:obj];
            [self.fileManager deleteDownFileWithName:model.fileName];
        }
    }];
    [self.userDefaults setObject:list forKey:RYCacheManager_DownVideo_Key];
    return [self.userDefaults synchronize];
}

- (BOOL)removeAllDownVideoModel {
    [self.userDefaults setObject:@[] forKey:RYCacheManager_DownVideo_Key];
    [self.fileManager deleteAllDownloadFile];
    return [self.userDefaults synchronize];
}

- (NSMutableArray <NSString *>*)downModels {
    NSArray <NSString *>* list = [self.userDefaults objectForKey:RYCacheManager_DownVideo_Key];
    if (list) {
        return [list mutableCopy];
    }
    return [[NSMutableArray alloc] init];
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

@end

