//
//  XYHTTPRequestManager.h
//  Risenb
//
//  Created by fabs on 2016/12/1.
//  Copyright © 2016年 Risenb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/UIButton+AFNetworking.h>

#import "NSFileManager+RYFileCategory.h"

#ifndef kXYSafeBlock
#define kXYSafeBlock(block,value) if (block) block(value)
#endif

typedef NS_ENUM(NSUInteger, XYRequestStatus) {
    XYRequestStatusFailure = 0,
    XYRequestStatusSuccessed
};

typedef NS_ENUM(NSUInteger, XYURLRequestCachePolicy) {
    XYURLRequestCachePolicyNormal = 0, // 不使用缓存
    XYURLRequestCachePolicyFailure,  // 请求失败时使用缓存
    XYURLRequestCachePolicyOnlyCache // 只使用缓存
};

@class XYResponseObject;

/**
 *  @brief  每次分页加载的数量.默认是10.
 */
UIKIT_EXTERN const NSInteger XYLimitCount;

@interface XYHTTPRequestManager : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)shareInstance;

/**
 *  @brief  网络状态
 */
@property (assign, nonatomic, readonly) AFNetworkReachabilityStatus networkReachabilityStatus;

/**
 *  @brief  网络是否可用
 */
@property (assign, nonatomic, readonly, getter = isReachable) BOOL reachable;

/**
 *  @brief  监听网络状态变化
 */
- (void)addObserverNetworkReachabilityStatus:(void(^)(AFNetworkReachabilityStatus status))block;

/**
 *  @brief  GET请求.不使用缓存
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(id)parameters
                              progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(void (^)(XYResponseObject *responseObject))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  @brief  GET分页请求
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                         page:(NSInteger)page
                   parameters:(id)parameters
                  cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                     progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                      success:(void (^)(XYResponseObject *responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  @brief  GET请求
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                     progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                      success:(void (^)(XYResponseObject *responseObject))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  @brief  POST请求.不使用缓存
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(XYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  @brief  POST分页请求.
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          page:(NSInteger)page
                    parameters:(id)parameters
                   cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(XYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  @brief  POST请求
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
                            cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                               progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(void (^)(XYResponseObject *responseObject))success
                                failure:(void (^)(NSError *error))failure;

/**
 *  @brief  文件上传
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                               progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(void (^)(XYResponseObject *responseObject))success
                                failure:(void (^)(NSError *error))failure;

/**
 *  @brief  文件下载
 */
- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)urlString
                                             parameters:(id)parameters
                                           didWriteData:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))didWriteData
                                               progress:(void (^)(NSProgress *progress))progress
                                                success:(void (^)(NSURL *fileURL))success
                                                failure:(void (^)(NSError *error))failure;
/**
 *  @brief  取消所有请求
 */
- (void)cancleAllRequest;

/**
 *  @brief 清除所有缓存
 */
- (void)clearAllCache;

@end

// ***********************************************************

@interface XYResponseObject : NSObject

/**
 *  @brief  是否是缓存的数据
 */
@property (assign, nonatomic, getter=isCache) BOOL cache;

/**
 *  @brief  请求结果状态
 */
@property (assign, nonatomic, readonly) XYRequestStatus status;

/**
 *  @brief  错误码
 */
@property (assign, nonatomic, readonly) NSInteger errorCode;

/**
 *  @brief  错误信息
 */
@property (copy, nonatomic, readonly) NSString *errorMsg;

/**
 *  @brief  请求数据
 */
@property (strong, nonatomic) id data;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary conversion:(BOOL)conversion;

@end
