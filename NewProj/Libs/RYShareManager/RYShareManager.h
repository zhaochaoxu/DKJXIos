//
//  RYShareManager.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/19.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface RYShareManager : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)shareInstacne;

- (void)shareInViewController:(UIViewController *)viewController
                      isMovie:(BOOL)isMovie
                 platformType:(UMSocialPlatformType)platform
                        title:(NSString *)title
                     subTitle:(NSString *)subTitle
                        thumb:(id)thumb
                          url:(NSString *)url
                   completion:(UMSocialRequestCompletionHandler)completion;

@end
