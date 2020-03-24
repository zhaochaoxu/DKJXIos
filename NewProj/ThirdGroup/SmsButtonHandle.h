//
//  SmsButtonHandle.h
//  NewProj
//
//  Created by 胡贝 on 2019/5/22.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SmsButtonHandle : NSObject
//验证码按钮单例封装
+ (instancetype)sharedSmsBHandle;

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action superVC:(UIViewController *)superVC;

- (void)startTimer;
@end

