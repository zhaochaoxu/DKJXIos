//
//  RYHTTPHeader.h
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/5.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYHTTPHeader : NSObject

extern NSString * const PICIDAPIURL;

#pragma mark - ServiceAddress
/**
 *  @brief  服务器地址
 */
//FOUNDATION_EXTERN NSString *const RYServiceAddress;
FOUNDATION_EXTERN NSString *const RYServiceAddress;

/**
 *  @brief  图片地址
 */
FOUNDATION_EXTERN NSString *const RYBaseImageAddress;
#pragma mark -

/**
 *  @brief  获取引导页
 */
FOUNDATION_EXTERN NSString *const API_APP_GetStartPage;

/**
 *  @brief  获取需要屏蔽的关键字
 */
FOUNDATION_EXTERN NSString *const API_KeyWorld_GetKeyWorld;

/**
 *  @brief  获取广告列表
 */
FOUNDATION_EXTERN NSString *const API_AdBanner_GetAdBannerList;

/**
 *  @brief  增加分享量
 */
FOUNDATION_EXTERN NSString *const API_Share_AddShareNum;

#pragma mark Login
//注册
FOUNDATION_EXTERN NSString *const API_User_Regist;
//验证码
FOUNDATION_EXTERN NSString *const API_User_SmsCode;
//登录
FOUNDATION_EXTERN NSString *const API_User_Login;
//修改密码
FOUNDATION_EXTERN NSString *const API_User_Modifypwd;
//验证验证码
FOUNDATION_EXTERN NSString *const API_User_CheckCode;
//第三方登录
FOUNDATION_EXTERN NSString *const API_User_ThirdLogin;
//获取设备ID
FOUNDATION_EXTERN NSString *const API_User_UpdateUserDevice;
/**
 *  @brief  获取剩余砖石
 */
FOUNDATION_EXPORT NSString *const API_User_GetDiamonds;

#pragma mark - Home
/**
 *  @brief  获取首页栏目列表
 */
FOUNDATION_EXTERN NSString *const API_Home_GetHomeData;

/**
 *  @brief  换一换
 */
FOUNDATION_EXTERN NSString *const API_Home_ChangeData;

/**
 *  @brief  首页加载更多接口
 */
FOUNDATION_EXTERN NSString *const API_Home_GetMoreData;

/**
 *  @brief  获取消息列表
 */
FOUNDATION_EXTERN NSString *const API_Home_GetMsgList;

/**
 *  @brief  编辑消息
 */
FOUNDATION_EXTERN NSString *const API_Home_EditMsg;

/**
 *  @brief  删除消息
 */
FOUNDATION_EXTERN NSString *const API_Home_DeleteMsg;

/**
 *  @brief  热门搜索标签
 */
FOUNDATION_EXTERN NSString *const API_Home_HotSearch;

/**
 *  @brief  搜索
 */
FOUNDATION_EXTERN NSString *const API_Home_Search;

/**
 *  @brief  获取选集（课程）列表
 */
FOUNDATION_EXTERN NSString *const API_Home_VideoCourses;

/**
 *  @brief 	视频详情
 */
FOUNDATION_EXTERN NSString *const API_Home_VideoDetails;

/**
 *  @brief  关注/订阅/点赞
 */
FOUNDATION_EXTERN NSString *const API_Home_Interact;

/**
 *  @brief  发表评论
 */
FOUNDATION_EXTERN NSString *const API_Home_CommentVideo;

/**
 *  @brief  获取评论列表
 */
FOUNDATION_EXTERN NSString *const API_Home_GetCommnetList;

/**
 *  @brief  获取活动详情
 */
FOUNDATION_EXPORT NSString *const API_Home_GetActivityDetails;

/**
 *  @brief  活动预告创建直播
 */
FOUNDATION_EXTERN NSString *const API_Live_CreatLive;

#pragma mark -

#pragma mark - Live

/**
 *  @brief  获取用户是否正在直播
 */
FOUNDATION_EXTERN NSString *const API_Live_GetLiveing;

/**
 *  @brief  获取直播列表
 */
FOUNDATION_EXTERN NSString *const API_Live_Lives;

/**
 *  @brief  观看/开始直播
 */
FOUNDATION_EXTERN NSString *const API_Live_LiveDetail;

/**
 *  @brief  获取话题列表
 */
FOUNDATION_EXTERN NSString *const API_Live_Topics;

/**
 *  @brief  直播活动预告
 */
FOUNDATION_EXTERN NSString *const API_Live_StartLive;

/**
 *  @brief  结束直播
 */
FOUNDATION_EXTERN NSString *const API_Live_EndLive;

/**
 *  @brief  删除我的直播回放
 */
FOUNDATION_EXTERN NSString *const API_Live_DeleteLive;

/**
 *  @brief  举报主播
 */
FOUNDATION_EXTERN NSString *const API_Live_Report;

/**
 *  @brief  获取礼物列表
 */
FOUNDATION_EXTERN NSString *const API_Live_Gifts;

/**
 *  @brief  赠送礼物
 */
FOUNDATION_EXPORT NSString *const API_Live_SendGift;

/**
 *  @brief  获取贡献榜列表
 */
FOUNDATION_EXTERN NSString *const API_Live_ContributionList;

/**
 *  @brief  获取直播观看人数/关注数/金币
 */
FOUNDATION_EXTERN NSString *const API_Live_GetLiveInfo;

/**
 *  @brief  用户退出直播
 */
FOUNDATION_EXTERN NSString *const API_Live_QuitLive;

#pragma mark -

#pragma mark - VIP
/**
 *  @brief  获取会员直播列表
 */
FOUNDATION_EXTERN NSString *const API_VIP_GetLives;

/**
 *  @brief  获取会员视频列表
 */
FOUNDATION_EXTERN NSString *const API_VIP_GetVideos;

/**
 *  @brief  获取会员列表信息
 */
FOUNDATION_EXTERN NSString *const API_VIP_List;
#pragma mark -

#pragma mark - Family
FOUNDATION_EXTERN NSString *const CUSTOMIMID;
#pragma mark -

#pragma mark - ME
/**
 *  @brief  获取用户实名状态
 */
FOUNDATION_EXTERN NSString *const API_User_GetRealStatus;
//获取用户信息
FOUNDATION_EXTERN NSString *const API_ME_UserInfo;
//上传文件
FOUNDATION_EXTERN NSString *const API_ME_Upload;
//签到
FOUNDATION_EXTERN NSString *const API_ME_Sign;
//关注/粉丝
FOUNDATION_EXTERN NSString *const API_ME_Follows;
//获取活动订单列表
FOUNDATION_EXTERN NSString *const API_ME_Orders;
//订单详情
FOUNDATION_EXTERN NSString *const API_ME_OrderDetails;
//我的账户
FOUNDATION_EXTERN NSString *const API_ME_UserAccountInfo;
//修改用户信息
FOUNDATION_EXTERN NSString *const API_ME_UpdateUserInfo;
//获取地址列表
FOUNDATION_EXTERN NSString *const API_ME_GetAddress;
//我的订阅
FOUNDATION_EXTERN NSString *const API_ME_Subscribe;
//商品列表
FOUNDATION_EXTERN NSString *const API_ME_ProductList;
//添加地址
FOUNDATION_EXTERN NSString *const API_ME_AddAddress;
//编辑地址
FOUNDATION_EXTERN NSString *const API_ME_UpdateAddress;
//实名认证
FOUNDATION_EXTERN NSString *const API_ME_Authentication;
//商品列表详情
FOUNDATION_EXTERN NSString *const API_ME_ProductDetails;
//我的购买
FOUNDATION_EXTERN NSString *const API_ME_Buy;
//签到信息
FOUNDATION_EXTERN NSString *const API_ME_SignToday;
//绑定手机号
FOUNDATION_EXTERN NSString *const API_ME_BindingTel;
//获取系统设置
FOUNDATION_EXTERN NSString *const API_ME_SignRules;
//意见反馈
FOUNDATION_EXTERN NSString *const API_ME_FreeBack;
//获取商品订单列表
FOUNDATION_EXTERN NSString *const API_ME_GoodsOrders;
//确认收货
FOUNDATION_EXTERN NSString *const API_ME_ConfirmReceipt;
//申请提现
FOUNDATION_EXTERN NSString *const API_ME_WithdrawCash;
//申请退款
FOUNDATION_EXTERN NSString *const API_ME_Refund;
//商品兑换
FOUNDATION_EXTERN NSString *const API_ME_BuyGood;
//获取未读消息
FOUNDATION_EXTERN NSString *const API_ME_GetMsgCount;
//视频订单
FOUNDATION_EXTERN NSString *const API_ME_BuyVideo;
//获取用户的认证状态
FOUNDATION_EXTERN NSString *const API_ME_GetUserStatus;
//获取启动页
FOUNDATION_EXTERN NSString *const API_ME_GetStartPage;
#pragma mark -

#pragma mark - Pay
/**
 *  @brief  生成订单
 */
FOUNDATION_EXPORT NSString *const API_Order_CreatOrderInfo;

/**
 *  @brief  苹果支付生成订单
 *  c       :   用户ID
 *  type    :   1余额充值 2钻石充值
 *  num     :   数量 50 100 200 500
 */
FOUNDATION_EXTERN NSString *const API_Order_ApplePay_CreatOrderInfo;

/**
 *  @brief  Apple Pay 回调
 */
FOUNDATION_EXTERN NSString *const API_Order_ApplePay_CallBack;

/**
 *  @brief  余额支付
 *  c           :   用户ID
 *  type        :   @see RYBusinessType
 *  productId   :   视频id（多个逗号分隔）直播id 群id 活动id vipId
 *  teacherId   :   邀请导师传入导师id
 */
FOUNDATION_EXTERN NSString *const API_Order_WalletPay;
#pragma mark -

@end
