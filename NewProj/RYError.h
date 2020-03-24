//
//  RYError.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/10.
//  Copyright © 2017年 fabs. All rights reserved.
//

#ifndef RYError_h
#define RYError_h

static NSString *const RYNetworkError = @"请检查您的网络";

static NSString *const RYConnectServerError = @"无法连接服务器,请检查链接地址是否正确";

static NSString *const RYConnectTimeOut = @"请求超时";

static NSString *const RYBadServerResponse = @"服务器响应错误";


#pragma mark ---------------- login ----------------
static NSString *const RYEmptyNickName = @"荣耀家族粉丝";

static NSString *const RYEmptySignature = @"这个家伙很懒,什么都没留下~";

static NSString *const RYUserName = @"请输入手机号";

static NSString *const RYTelErroe = @"短信发送失败";

static NSString *const RYTelAlreadyUse = @"注册失败，号码已经被注册";

static NSString *const RYCodeError = @"验证码错误";

static NSString *const RYPasswordError = @"2次输入的密码不一致，请重新确认设置的密码";

static NSString *const RYPasswordNil = @"请输入密码";

static NSString *const RYPasswordnil = @"密码不能为空";

static NSString *const RYUserPassError = @"账号密码错误";

static NSString *const RYUserPrompt = @"请输入您的手机号码";

static NSString *const RYCodePrompt = @"请输入验证码";

static NSString *const RYUserPassNilPrompt = @"请正确输入手机号码";

static NSString *const RYUserNilPrompt = @"验证失败";

#pragma mark - Search
static NSString *const RYSearchResultIsFull = @"未找到相关记录!";
#pragma mark -

#pragma mark - Live 
static NSString *const RYIsRealingMessage = @"实名认证审核中!";

static NSString *const RYIsRealErrorMessage = @"实名认证未通过，请重新提交";

static NSString *const RYSubmitActivitySuccess = @"直播预告信息已经提交后台审核!";

static NSString *const RYLiveMessageSendError = @"消息发送失败";
#pragma mark -

#endif /* RYError_h */
