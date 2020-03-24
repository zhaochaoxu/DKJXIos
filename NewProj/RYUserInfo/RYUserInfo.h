//
//  RYUserInfo.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/5/17.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTSaveCachesFile.h"

UIKIT_EXTERN NSString *const RYUserSetUpIsPlayOnWiFiKey;
UIKIT_EXTERN NSString *const RYUserSetUpIsDownOnWiFiKey;

@interface RYUserInfo : NSObject

/*
   用户信息
*/

+ (NSString *)birthday;        //出生日期

+ (NSString *)idCard;          //身份证号

+ (NSString *)fans;            //总粉丝数

+ (NSString *)follows;         //总关注量

+ (NSString *)honourBalance;   //账户余额,现金余额

+ (NSString *)honourCurrency;  //荣耀币

+ (NSString *)honourDiamonds;  //荣耀钻石

+ (NSString *)uid;             //"用户ID(唯一标识)

+ (NSString *)imId;            //即时通讯ID

+ (NSString *)imPwd;           //即时通讯密码

+ (NSString *)isReal;          //用户认证状态，0未认证，1审核中，2审核不通过，5已认证

+ (NSString *)liveNum;         //直播总数量

+ (NSString *)mytags;          //自定义标签

+ (NSString *)nickname;        //用户昵称

+ (NSString *)tel;             //手机号

+ (NSString *)price;           //导师用户被邀请价格

+ (NSString *)qrcode;          //分销码记录ID

+ (NSString *)realName;        //真实姓名

+ (NSString *)registerCity;    //注册城市

+ (NSString *)sex;             //性别

+ (NSString *)sign;            //个性签名

+ (NSString *)status;          //状态 0-正常  1-冻结（前不显 后显） 100-删除

+ (NSString *)tags;            //系统标签

+ (NSString *)type;            //用户类型 0普通用户 1 导师

+ (NSString *)userIcon;        //用户头像

+ (NSString *)username;        //用户的规则编号 用户U开头 名师M开头

+ (NSString *)videoNum;        //视频总数量

+ (NSString *)vip;             //用户vip类型 0-非vip   1:荣耀会员  4:普通会员

+ (NSString *)vipTime;         //vip到期时间 默认0000-00-00 00:00:00

+ (NSString *)wxAccount;       //绑定的微信号

+ (NSString *)zfbAccount;      //绑定的支付宝账号

+ (NSString *)serverTel;       //客服电话

/*
  保存用户信息
 */
+ (void)addValue:(id)value forKey:(NSString *)key;

/*
  删除用户信息
 */
+ (void)EmptyUserInfo;


/**
 *  @brief  验证用户是否可以开启直播
 *  @param  authorized  未实名认证
 *  @param  ordinary    普通用户
 *  @param  mentor      导师
 */
+ (void)userIsRealWithAuthorized:(void(^)())authorized
                        ordinary:(void(^)(NSInteger isReal))ordinary
                          mentor:(void(^)())mentor;



@end
