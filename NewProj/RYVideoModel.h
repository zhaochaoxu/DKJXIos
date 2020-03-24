//
//  RYVideoModel.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/12.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RYVideoModel : JSONModel

/**
 *  @brief  视屏图片.
 */
@property (copy, nonatomic) NSString *thumb;

/**
 *  @brief  视屏标题
 */
@property (copy, nonatomic) NSString *title;

/**
 *  @brief  下载路径.
 */
@property (copy, nonatomic) NSString *url;

/**
 *  @brief  视屏文件名称
 */
@property (copy, nonatomic, readonly) NSString *fileName;

/**
 *  @brief  是否正在下载
 */
@property (assign, nonatomic, readonly) BOOL isRuning;

/**
 *  @brief  是否下载完成
 */
@property (assign, nonatomic, readonly) BOOL isCompleted;

/**
 *  @brief  当前视频播放到的桢数
 */
@property (assign, nonatomic) int64_t playedTime;

/**
 *  @brief  当前视频的总桢数
 */
@property (assign, nonatomic) int64_t totalTime;

/**
 *  @brief  每秒的帧数. 用来创建 CMTime
 */
@property (assign, nonatomic) int32_t timescale;

/**
 *  @brief  视屏缓存大小
 */
@property (assign, nonatomic, readonly) int64_t totalBytesWritten;

/**
 *  @brief  视屏总大小
 */
@property (assign, nonatomic, readonly) int64_t totalBytesExpectedToWrite;

/**
 *  @brief  初始化方法
 */
- (instancetype)initWithURL:(NSString *)url
                      title:(NSString *)title
                      thubm:(NSString *)thubm;

/**
 *  @brief  是否播放完成.
 */
- (BOOL)isPlayedFinished;

/**
 *  @brief  开始下载
 */
- (void)startDownloadWithParameters:(id)parameters
                               progress:(void (^)(NSProgress *progress))progress
                                success:(void (^)(NSURL *fileURL))success
                                failure:(void (^)(NSError *error))failure;

/**
 *  @brief  取消下载
 */
- (void)cancle;

@end
