//
//  RYShareManager.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/19.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYShareManager.h"

@implementation RYShareManager

+ (instancetype)shareInstacne {
   static RYShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[[self class] alloc] init];
        }
    });
    return manager;
}

- (void)shareInViewController:(UIViewController *)viewController
                      isMovie:(BOOL)isMovie
                 platformType:(UMSocialPlatformType)platform
                        title:(NSString *)title
                     subTitle:(NSString *)subTitle
                        thumb:(id)thumb
                          url:(NSString *)url
                   completion:(UMSocialRequestCompletionHandler)completion {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (isMovie) {
        UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:subTitle thumImage:thumb];
        shareObject.videoUrl = [self safeMovieURLWithString:url];
        messageObject.shareObject = shareObject;
    }else{
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:subTitle thumImage:thumb];
        shareObject.webpageUrl = [NSURL URLWithString:url].absoluteString;
        messageObject.shareObject = shareObject;
    }
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:viewController completion:completion];
}

- (NSString *)safeMovieURLWithString:(NSString *)string {
    if ([string hasPrefix:@"https://"] || [string hasPrefix:@"http://"]) {
        return string;
    }
    if (![[string substringToIndex:1] isEqualToString:@"/"]) {
        string = [@"/upload/" stringByAppendingString:string];
    }
    return [RYServiceAddress stringByAppendingString:string];
}

@end
