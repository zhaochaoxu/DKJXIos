//
//  RYDatabaseManager.m
//  HRRongYaoApp
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYDatabaseManager.h"

@interface RYDatabaseManager ()
@property (nonatomic ,strong)FMDatabase *db;

@end
@implementation RYDatabaseManager


+ (RYDatabaseManager *)sharedManager
{
    static RYDatabaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RYDatabaseManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        //1,创建数据库
        self.db = [FMDatabase databaseWithPath:[self dbPath]];
        
        BOOL ret = [self.db open];
        NSLog(@"打开数据库: %@", ret ? @"成功!" : @"失败!");
        
        //2, 创建表
        [self createTable];
        
    }
    return self;
}

//2, 创建表
- (void)createTable
{
    NSString *sql = @"create table if not exists User(id integer primary key autoincrement,uuid text, cover text, videoId text, url text, isFree text, isBuy text, duration text, videoTime text, advertisementUrl text, title text, summary text,courseId text, price text)";
    
    BOOL ret = [self.db executeUpdate:sql];
    NSLog(@"创建表: %@", ret ? @"成功!" : @"失败!");
}


//插入数据
- (void)insertUser:(RYDatabaseManagerModel *)model
{
    NSArray *arr = [self getAllDatas];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        RYDatabaseManagerModel *arrmodel = arr[i];
        if ([model.videoId isEqualToString:arrmodel.videoId]) {
            return ;
        }
    }

    NSString *sql = @"insert into User(uuid,cover,videoId,url,isFree,isBuy,duration,videoTime,advertisementUrl,title,summary,courseId,price) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    //插入
    [self.db executeUpdate:sql,model.uuid, model.cover,model.videoId,model.url,model.isFree,model.isBuy,model.duration,model.videoTime,model.advertisementUrl,model.title,model.summary,model.courseId,model.price];

}

//查询数据
- (NSArray *)getAllDatas
{
    NSMutableArray *mArr = [NSMutableArray new];
    
    NSString *sql = @"select * from User";
    
    FMResultSet *set = [self.db executeQuery:sql];
    
    //遍历获取所有数据
    while ([set next]) {
        
        int index = [set intForColumn:@"id"]; //id
        NSString *cover = [set stringForColumn:@"cover"];
        NSString *videoId = [set stringForColumn:@"videoId"];
        NSString *url = [set stringForColumn:@"url"];
        NSString *isFree = [set stringForColumn:@"isFree"];
        NSString *isBuy = [set stringForColumn:@"isBuy"];
        NSString *duration = [set stringForColumn:@"duration"];
        NSString *videoTime = [set stringForColumn:@"videoTime"];
        NSString *advertisementUrl = [set stringForColumn:@"advertisementUrl"];
        NSString *title = [set stringForColumn:@"title"];
        NSString *summary = [set stringForColumn:@"summary"];
        NSString *uuid = [set stringForColumn:@"uuid"];
        NSString *courseId = [set stringForColumn:@"courseId"];
        NSString *price = [set stringForColumn:@"price"];
        
        RYDatabaseManagerModel *model = [[RYDatabaseManagerModel alloc] init];
        model.index = @(index);
        model.cover = cover;
        model.videoId = videoId;
        model.url = url;
        model.isFree = isFree;
        model.isBuy = isBuy;
        model.duration = duration;
        model.videoTime = videoTime;
        model.advertisementUrl = advertisementUrl;
        model.title = title;
        model.summary = summary;
        model.uuid = uuid;
        model.courseId = courseId;
        model.price = price;

        //添加model
        [mArr addObject:model];
    }
    
    return mArr;
}

//删除数据
- (BOOL)deleteUser:(RYDatabaseManagerModel *)model
{
    NSString *sql = @"delete from User where id=?";
    
    return [self.db executeUpdate:sql,model.index];
}

//更新数据
- (void)updateUser:(RYDatabaseManagerModel *)model
{
    if (!model.index) {
        NSArray *arr = [self getAllDatas];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RYDatabaseManagerModel *allModel = arr[idx];
            if ([allModel.videoId isEqualToString:model.videoId]) {
                model.index = allModel.index;
            }
        }];
    }
    NSString *sql = @"update User set uuid=?,cover=?,videoId=?,url=?,isFree=?,isBuy=?,duration=?,videoTime=?,advertisementUrl=?,title=?,summary=?,courseId=?,price=? where id=?";
    [self.db executeUpdate:sql,model.uuid, model.cover,model.videoId,model.url,model.isFree,model.isBuy,model.duration,model.videoTime,model.advertisementUrl,model.title,model.summary,model.courseId,model.price,model.index];
    
}

//返回数据库的存储路径
- (NSString *)dbPath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [path stringByAppendingPathComponent:@"appWatchRecord.db"];
}

- (void)dealloc
{
    [self.db close];
}


@end
