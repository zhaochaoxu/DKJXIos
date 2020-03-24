//
//  RYVideoModel.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/12.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYVideoModel.h"

@interface RYVideoModel ()

@property (strong, nonatomic) NSURLSessionDownloadTask *task;

@end

@implementation RYVideoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (instancetype)initWithURL:(NSString *)url
                      title:(NSString *)title
                      thubm:(NSString *)thubm {
    self = [super init];
    if (self) {
        self.url = [url copy];
        self.title = [title copy];
        self.thumb = [thubm copy];
    }
    return self;
}

- (NSString *)fileName {
    return self.url.lastPathComponent;
}

- (BOOL)isRuning {
    return self.task.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isCompleted {
    return self.task.state == NSURLSessionTaskStateCompleted;
}

- (int64_t)totalBytesWritten {
    return self.task.countOfBytesReceived;
}

- (int64_t)totalBytesExpectedToWrite {
    return self.task.countOfBytesExpectedToReceive;
}

- (BOOL)isPlayedFinished {
    if (self.playedTime && self.totalTime) {
        return self.playedTime == self.totalTime;
    }
    return NO;
}

- (void)startDownloadWithParameters:(id)parameters
                           progress:(void (^)(NSProgress *progress))progress
                            success:(void (^)(NSURL *fileURL))success
                            failure:(void (^)(NSError *error))failure{
    [self cancle];
    self.task = [[XYHTTPRequestManager shareInstance] downloadTaskWithURLString:self.url parameters:parameters didWriteData:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
    } progress:progress success:success failure:failure];
}

- (void)cancle {
    if (self.task) {
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *filePath = [[[NSFileManager defaultManager] cacheFilePath] stringByAppendingPathComponent:self.fileName];
                [resumeData writeToFile:filePath atomically:YES];
            });
        }];
    }
}
@end
