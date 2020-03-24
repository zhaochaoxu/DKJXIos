 //
//  XYHTTPRequestManager.m
//  Risenb
//
//  Created by fabs on 2016/12/1.
//  Copyright © 2016年 Risenb. All rights reserved.
//

#import "XYHTTPRequestManager.h"
#import "TMCache.h"

static NSString *const XYPageKey = @"page";
static NSString *const XYLimitKey = @"limit";
const  NSInteger XYLimitCount = 10;

@interface XYHTTPRequestManager ()

@property (strong, nonatomic, readonly) AFNetworkReachabilityManager *networkReachabitityManager;

@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic, readonly) TMCache *cache;

@property (strong, nonatomic, readonly) NSFileManager *fileManager;

@end

@implementation XYHTTPRequestManager
@synthesize networkReachabitityManager = _networkReachabitityManager;
@synthesize sessionManager = _sessionManager;
@synthesize cache = _cache;
@synthesize fileManager = _fileManager;

- (void)dealloc {
    [self cancleAllRequest];
    [self.networkReachabitityManager stopMonitoring];
}

#pragma mark - Pubilc Methods
+ (instancetype)shareInstance {
    static XYHTTPRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[[self class] alloc] init];
            [manager.networkReachabitityManager startMonitoring];
        }
    });
    return manager;
}

- (void)addObserverNetworkReachabilityStatus:(void(^)(AFNetworkReachabilityStatus status))block {
    [self.networkReachabitityManager stopMonitoring];
    [self.networkReachabitityManager setReachabilityStatusChangeBlock:block];
    [self.networkReachabitityManager startMonitoring];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                      success:(void (^)(XYResponseObject *responseObject))success
                      failure:(void (^)(NSError *error))failure {
    return [self GET:URLString
          parameters:parameters
         cachePolicy:XYURLRequestCachePolicyNormal
            progress:downloadProgress
             success:success
             failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                         page:(NSInteger)page
                   parameters:(id)parameters
                  cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                     progress:(void (^)(NSProgress *))downloadProgress
                      success:(void (^)(XYResponseObject *))success
                      failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameter = [parameters mutableCopy];
    [parameter setObject:@(page).stringValue forKey:XYPageKey];
    [parameter setObject:@(XYLimitCount).stringValue forKey:XYLimitKey];
    return [self GET:URLString
          parameters:parameter
         cachePolicy:cachePolicy
            progress:downloadProgress
             success:success
             failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                     progress:(void (^)(NSProgress *))downloadProgress
                      success:(void (^)(XYResponseObject *))success failure:(void (^)(NSError *))failure{
    NSString *cacheKey = [self cacheKeyWithURLString:URLString parameters:parameters];
    BOOL isNeedConversion = [self isNeedConversionWithParameters:parameters];
    if (cachePolicy == XYURLRequestCachePolicyOnlyCache) {
        id data = [self.cache objectForKey:cacheKey];
        XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
        if (object) {
            object.cache = YES;
            kXYSafeBlock(success,object);
        }else{
            kXYSafeBlock(failure,[NSError errorWithDomain:@"The Cahce Data is nil." code:NSNotFound userInfo:nil]);
        }
        return nil;
    }
    return [self.sessionManager GET:URLString
                         parameters:parameters
                           progress:downloadProgress
                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:responseObject conversion:isNeedConversion];
                                object.cache = NO;
                                switch (cachePolicy) {
                                    case XYURLRequestCachePolicyNormal:{
                                    }break;
                                    case XYURLRequestCachePolicyFailure:{
                                        if (object && object.status == XYRequestStatusSuccessed) {
                                            [self.cache setObject:responseObject forKey:cacheKey];
                                        }
                                    }break;
                                    case XYURLRequestCachePolicyOnlyCache:{
                                        id data = [self.cache objectForKey:cacheKey];
                                        if (data) {
                                            object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
                                            object.cache = YES;
                                        }else{
                                            kXYSafeBlock(failure,[NSError errorWithDomain:@"The Cache is nil." code:NSNotFound userInfo:nil]);
                                            return ;
                                        }
                                    }break;
                                }
                                kXYSafeBlock(success,object);
                            }
                            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                switch (cachePolicy) {
                                    case XYURLRequestCachePolicyNormal:{
                                        kXYSafeBlock(failure,error);
                                        return ;
                                    }break;
                                    case XYURLRequestCachePolicyFailure:
                                    case XYURLRequestCachePolicyOnlyCache:{
                                        id data = [self.cache objectForKey:cacheKey];
                                        if (data) {
                                            XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
                                            object.cache = YES;
                                            kXYSafeBlock(success, object);
                                            return;
                                        }else{
                                            kXYSafeBlock(failure,error);
                                            return ;
                                        }
                                    }break;
                                }
                            }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(XYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure {
    return [self POST:URLString
           parameters:parameters
          cachePolicy:XYURLRequestCachePolicyNormal
             progress:uploadProgress
              success:success
              failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                          page:(NSInteger)page
                    parameters:(id)parameters
                   cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(XYResponseObject *))success
                       failure:(void (^)(NSError *))failure {
    NSMutableDictionary *parameter = [parameters mutableCopy];
    [parameter setObject:@(page).stringValue forKey:XYPageKey];
    [parameter setObject:@(XYLimitCount).stringValue forKey:XYLimitKey];
    return [self POST:URLString
           parameters:parameter
          cachePolicy:cachePolicy
             progress:uploadProgress
              success:success
              failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                   cachePolicy:(XYURLRequestCachePolicy)cachePolicy
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(XYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSString *cacheKey = [self cacheKeyWithURLString:URLString parameters:parameters];
    BOOL isNeedConversion = [self isNeedConversionWithParameters:parameters];
    if (cachePolicy == XYURLRequestCachePolicyOnlyCache) {
        id data = [self.cache objectForKey:cacheKey];
        XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
        if (object) {
            object.cache = YES;
            kXYSafeBlock(success,object);
        }else{
            kXYSafeBlock(failure,[NSError errorWithDomain:@"The Cahce Data is nil." code:NSNotFound userInfo:nil]);
        }
        return nil;
    }
    return [self.sessionManager POST:URLString
                          parameters:parameters
                            progress:uploadProgress
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:responseObject conversion:isNeedConversion];
                                 object.cache = NO;
                                 switch (cachePolicy) {
                                     case XYURLRequestCachePolicyNormal:{
                                     }break;
                                     case XYURLRequestCachePolicyFailure:{
                                         if (object && object.status == XYRequestStatusSuccessed) {
                                             [self.cache setObject:responseObject forKey:cacheKey];
                                         }
                                     }break;
                                     case XYURLRequestCachePolicyOnlyCache:{
                                         id data = [self.cache objectForKey:cacheKey];
                                         if (data) {
                                             object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
                                             object.cache = YES;
                                         }else{
                                             kXYSafeBlock(failure, [NSError errorWithDomain:@"The Cache is nil." code:NSNotFound userInfo:nil]);
                                             return ;
                                         }
                                     }break;
                                 }
                                 kXYSafeBlock(success, object);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 switch (cachePolicy) {
                                     case XYURLRequestCachePolicyNormal:{
                                         kXYSafeBlock(failure,error);
                                         return ;
                                     }break;
                                     case XYURLRequestCachePolicyFailure:
                                     case XYURLRequestCachePolicyOnlyCache:{
                                         id data = [self.cache objectForKey:cacheKey];
                                         if (data) {
                                             XYResponseObject *object = [[XYResponseObject alloc] initWithDictionary:data conversion:isNeedConversion];
                                             object.cache = YES;
                                             kXYSafeBlock(success,object);
                                             return;
                                         }else{
                                             kXYSafeBlock(failure,error);
                                             return ;
                                         }
                                     }break;
                                 }
                             }];
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       success:(void (^)(XYResponseObject *responseObject))success
                       failure:(void (^)(NSError *error))failure {
    
    BOOL isNeedConversion = [self isNeedConversionWithParameters:parameters];
    return [self.sessionManager POST:URLString
                          parameters:parameters
           constructingBodyWithBlock:block
                            progress:uploadProgress
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                
                                 XYResponseObject *response = [[XYResponseObject alloc] initWithDictionary:responseObject conversion:isNeedConversion];
                                 kXYSafeBlock(success, response);
                             }
                             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 kXYSafeBlock(failure, error);
                             }];
}

- (NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)urlString
                                             parameters:(id)parameters
                                           didWriteData:(void(^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))didWriteData
                                               progress:(void (^)(NSProgress *progress))progress
                                                success:(void (^)(NSURL *fileURL))success
                                                failure:(void (^)(NSError *error))failure {
    //http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg
    NSString *Suffix = [urlString lastPathComponent];
    NSString *document;
    if ([Suffix containsString:@".png"]) {
        document = [self.fileManager fileDocuments];
    }else if ([Suffix containsString:@".mp4"]){
       document = [self.fileManager videoDocuments];
    }
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    AFHTTPSessionManager *downloadManager = [AFHTTPSessionManager manager];
    [downloadManager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (didWriteData) {
            didWriteData(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    NSData *data = [self.fileManager dataAtCacheFileWithName:urlRequest.URL.absoluteString.lastPathComponent];
    if (data) {
        NSURLSessionDownloadTask *task = [downloadManager downloadTaskWithResumeData:data progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:[document stringByAppendingPathComponent:response.suggestedFilename]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                kXYSafeBlock(failure, error);
            }else{
                [self.fileManager deleteCacheFileWithName:response.URL.absoluteString.lastPathComponent];
                kXYSafeBlock(success, filePath);
            }
        }];
       
        [task resume];
        return task;
    }
    
    NSURLSessionDownloadTask *task = [downloadManager downloadTaskWithRequest:urlRequest progress:progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:[document stringByAppendingPathComponent:response.suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            kXYSafeBlock(failure, error);
        }else{
            [self.fileManager deleteCacheFileWithName:response.URL.absoluteString.lastPathComponent];
            kXYSafeBlock(success, filePath);
        }
    }];


    [task resume];
    return task;
}

- (void)cancleAllRequest{
    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)clearAllCache {
    [self.cache removeAllObjects];
}
#pragma mark -

#pragma mark - Private Methods
- (NSString *)cacheKeyWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSMutableString *string = [[NSMutableString alloc] initWithString:URLString];
    [string appendString:@"?"];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    return [[[[self uid] stringByAppendingString:string] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

/* 根据请求参数判断是否是分页请求,用于判断请求结果是否需要把errorCode=400 转成正常流程 */
- (BOOL)isNeedConversionWithParameters:(NSDictionary *)parameters {
    return [parameters.allKeys containsObject:XYLimitKey] && [parameters.allKeys containsObject:@"page"];
}
#pragma mark -

#pragma mark - Setting and Getting Methods
- (AFNetworkReachabilityStatus)networkReachabilityStatus {
    return self.networkReachabitityManager.networkReachabilityStatus;
}

- (BOOL)isReachable {
    return [self.networkReachabitityManager isReachable];
}

- (NSString *)uid {
    return @"";
}

- (AFNetworkReachabilityManager *)networkReachabitityManager {
    if (!_networkReachabitityManager) {
        _networkReachabitityManager = [AFNetworkReachabilityManager sharedManager];
    }
    return _networkReachabitityManager;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:RYServiceAddress]];
        _sessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 3;
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        _sessionManager.responseSerializer = responseSerializer;
    }
    return _sessionManager;
}

- (TMCache *)cache {
    if (!_cache) {
        _cache = [TMCache sharedCache];
        _cache.memoryCache.costLimit = 1024 * 1024 * 4;     //4MB
        _cache.diskCache.byteLimit = 1024 * 1024 * 20;      //20MB
        _cache.diskCache.ageLimit = 60 * 60 * 24 * 7;       //7days
    }
    return _cache;
}

- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}
#pragma mark -
@end

static NSString *const XYStatusKey = @"status";
static NSString *const XYErrorCodeKey = @"errorCode";
static NSString *const XYErrorMsgKey = @"errorMsg";
static NSString *const XYDataKey = @"data";

/**
 *  @brief  没有更多数据.
 */
static const NSInteger RYNoMoreData = 400;

@implementation XYResponseObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary conversion:(BOOL)conversion {
    self = [super init];
    if (self) {
        if (!dictionary) {
            return nil;
        }
        _status = [[NSString stringWithFormat:@"%@",[dictionary objectForKey:XYStatusKey]] boolValue];
        _data = [dictionary objectForKey:XYDataKey];
        _errorMsg = [dictionary objectForKey:XYErrorMsgKey];
        _errorCode = [[dictionary objectForKey:XYErrorCodeKey] integerValue];
        if (conversion) {
            [self conversionStatus];
        }
    }
    return self;
}

/**
 *  @brief  将没有数据,转换成正常流程.
 */
- (void)conversionStatus{
    if (self.status == XYRequestStatusFailure && self.errorCode == RYNoMoreData && [_data isKindOfClass:[NSArray class]]) {
        _status = XYRequestStatusSuccessed;
    }
}

@end
