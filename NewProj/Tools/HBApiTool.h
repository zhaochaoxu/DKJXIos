//
//  HBApiTool.h
//  NewProj
//
//  Created by 胡贝 on 2019/3/13.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//http://dili.bdatu.com/jiekou/main/p1.html


typedef NS_ENUM(NSUInteger, RequestStatus) {
    RequestStatusSuccess = 0, // 从顶部出现.未实现.
    RequestStatusFailure
};
@interface HBApiTool : NSObject

//获取好友列表

+ (void)GetHomePictureWithPage:(NSInteger )page
                       success:(void(^)(NSArray *))success
                       failure:(void(^)(NSString *errormsg))failure;

+ (void)picBrowseGet:(NSInteger )urlNum
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure;

+ (void)GetStoryWithNum:(NSInteger )num
                success:(void(^)(NSString *))success
                failure:(void(^)(NSError *))failure;



+ (void)GetRegionWithSuccess:(void(^)(NSArray *array))success
                     failure:(void(^)(NSError *error))failure;

+ (void)GetCuisineWithSuccess:(void(^)(NSArray *array))success
                     failure:(void(^)(NSError *error))failure;

+ (void)GetMenuListWithLongitude:(NSString *)longitude
                        latitude:(NSString *)latitude
                       bussHubId:(NSString *)bussHubId
                   cuisineTypeID:(NSString *)cuisineTypeID
                          pageNO:(NSString *)pageNO
                         success:(void(^)(NSDictionary *dict))success
                         failure:(void(^)(NSError *error))failure;

//发送验证码
+ (void)GetVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                             success:(void(^)(BOOL data))success
                             failure:(void(^)(NSError *error))failure;

//注册
+ (void)PostRegisterWithNickname:(NSString *)nickname
                     phoneNumber:(NSString *)phoneNumber
                      verifyCode:(NSString *)verifyCode
                        password:(NSString *)password
                         success:(void(^)(NSDictionary *array))success
                         failure:(void(^)(NSError *error))failure;




//取得登录用户信息
+ (void)GetUserInfoWithTel:(NSString *)tel
                  password:(NSString *)password
                 weChatUID:(NSString *)weChatUID
                  weChatNO:(NSString *)weChatNO
                       sex:(NSString *)sex
                   imgpath:(NSString *)imgpath
                  nickname:(NSString *)nickname
                   msgCode:(NSString *)msgCode
                   success:(void(^)(NSDictionary *dict))success
                   failure:(void(^)(NSError *error))failure;

//个人信息设置
+ (void)PostModifyUserInfoWithNickname:(NSString *)nickname
                                  sex:(NSString *)sex
                                birth:(NSString *)birth
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure;


//绑定手机号
+ (void)PostBindCellPhoneWithPhoneNum:(NSString *)tel
                              msgCode:(NSString *)msgCode
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure;


//获取个人信息
+ (void)GetUserInfoWithsuccess:(void(^)(NSDictionary *dict))success
                       failure:(void(^)(NSError *error))failure;


//吃过的招牌菜
+ (void)GetSpecialityEatenWithSuccess:(void(^)(NSArray *array))success
                              failure:(void(^)(NSError *error))failure;

//想吃的招牌菜
+ (void)GetWantSpecialityWithSuccess:(void(^)(NSArray *array))success
                             failure:(void(^)(NSError *error))failure;

//商家详情
+ (void)GetMechantDetailsWithMechantId:(NSString *)mechantId
                               success:(void(^)(NSDictionary *dict))success
                               failure:(void(^)(NSError *error))failure;

//获取access_token

+ (void)getAccessTokenWithRespCode: (NSString*)respCode
                          callback: (void(^) (RequestStatus, NSString *str))callback;

//获取userinfo
+ (void)getUserInfoWithCallback: (void(^) (RequestStatus, NSString*))callbackf;

+ (void)PostWeiXinPayWithTotalPrice:(NSString *)totalPrice
                               body:(NSString *)body
                           trade_no:(NSString *)trade_no
                         consumerID:(NSString *)consumerID
                            success:(void(^)(NSDictionary *dict))success
                            failure:(void(^)(NSError *error))failure;

//收藏
+ (void)PostCollectionLoveWithMerchantID:(NSString *)merchantID
                              consumerID:(NSString *)consumerID
                                 success:(void(^)(NSDictionary *dict))success
                                 failure:(void(^)(NSError *error))failure;

//取消收藏
+ (void)PostCancelCollectionLoveWithMerchantID:(NSString *)merchantID
                                    consumerID:(NSString *)consumerID
                                       success:(void(^)(NSDictionary *dict))success
                                       failure:(void(^)(NSError *error))failure;


//查询
+ (void)GetQueryPaySuccessOrderWithID:(NSString *)consumerID
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure;


//查询会员是否过期
+ (void)GetMembershipExpiresWithCheckDate:(NSString *)checkDate
                                  success:(void(^)(NSDictionary *dict))success
                                  failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
