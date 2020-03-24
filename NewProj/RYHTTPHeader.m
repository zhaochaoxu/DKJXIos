//
//  RYHTTPHeader.m
//  HRRongYaoApp
//
//  Created by fabs on 2017/4/5.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYHTTPHeader.h"

@implementation RYHTTPHeader

NSString * const PICIDAPIURL                =  @"http://dili.bdatu.com/jiekou/album/a";



#if DEBUG

//NSString *const RYServiceAddress = @"http://124.204.45.69:6666";
//NSString *const RYServiceAddress = @"http://192.168.1.215:8012";

//正式环境
NSString *const RYServiceAddress = @"http://www.dakajingxuan.com:8012";



NSString *const RYBaseImageAddress = @"http://ryjz.4pole.cn/upload";
#else
NSString *const RYServiceAddress = @"http://www.dakajingxuan.com:8012";
NSString *const RYBaseImageAddress = @"http://ryjz.4pole.cn/upload";
#endif

NSString *const API_APP_GetStartPage = @"/api/home/getStartPage";

NSString *const API_KeyWorld_GetKeyWorld = @"/api/my/getKeyWorld";

NSString *const API_AdBanner_GetAdBannerList = @"/api/home/getAdvertList";

NSString *const API_Share_AddShareNum = @"/api/share/addShareNum";

#pragma mark - User
NSString *const API_User_Regist = @"/api/user/regist";

NSString *const API_User_SmsCode = @"/api/user/smsCode";

NSString *const API_User_Login = @"/api/user/login";

NSString *const API_User_Modifypwd = @"/api/user/modifyPwd";

NSString *const API_User_CheckCode = @"/api/user/checkCode";

NSString *const API_User_ThirdLogin = @"/api/user/thirdLogin";

NSString *const API_User_GetDiamonds = @"/api/user/getDiamonds";

NSString *const API_User_UpdateUserDevice = @"/api/user/updateUserDevice";
#pragma mark -

#pragma mark - Home
NSString *const API_Home_GetHomeData = @"/api/home/getHomeData";

NSString *const API_Home_ChangeData = @"/api/home/change";

NSString *const API_Home_GetMoreData = @"/api/home/getMoreData";

NSString *const API_Home_GetMsgList = @"/api/home/getMsg";

NSString *const API_Home_EditMsg = @"/api/home/editMsg";

NSString *const API_Home_DeleteMsg = @"/api/home/deleteMsg";

NSString *const API_Home_HotSearch = @"/api/home/hotSearch";

NSString *const API_Home_Search = @"/api/home/search";

NSString *const API_Home_VideoCourses = @"/api/home/videoCourses";

NSString *const API_Home_VideoDetails = @"/api/home/videoDetail";

NSString *const API_Home_Interact = @"/api/home/interact";

NSString *const API_Home_CommentVideo = @"/api/home/commentVideo";

NSString *const API_Home_GetCommnetList = @"/api/home/getComments";

NSString *const API_Home_GetActivityDetails = @"/api/home/activityDetails";

NSString *const API_Live_CreatLive = @"/api/live/createLive";
#pragma mark -

#pragma mark - Live
NSString *const API_Live_GetLiveing = @"/api/live/getLiving";

NSString *const API_Live_Lives = @"/api/live/lives";

NSString *const API_Live_LiveDetail = @"/api/live/liveDetail";

NSString *const API_Live_StartLive = @"/api/live/startLive";

NSString *const API_Live_Topics = @"/api/live/topics";

NSString *const API_Live_EndLive = @"/api/live/endLive";

NSString *const API_Live_DeleteLive = @"/api/live/deleteLive";

NSString *const API_Live_Report = @"/api/live/report";

NSString *const API_Live_Gifts = @"/api/live/gifts";

NSString *const API_Live_SendGift = @"/api/live/sendGift";

NSString *const API_Live_ContributionList = @"/api/live/contributionList";

NSString *const API_Live_GetLiveInfo = @"/api/live/liveInfo";

NSString *const API_Live_QuitLive = @"/api/live/quitLive";
#pragma mark -

#pragma mark - VIP
NSString *const API_VIP_GetLives = @"/api/vip/lives";

NSString *const API_VIP_GetVideos = @"/api/vip/videos";

NSString *const API_VIP_List = @"/api/vip/list";
#pragma mark -


#pragma mark - Family
NSString *const CUSTOMIMID = @"honour_1495769102";

#pragma mark -

#pragma mark - me
NSString *const API_User_GetRealStatus = @"/api/user/getUserStatus";

NSString *const API_ME_UserInfo = @"/api/user/getUserInfo";

NSString *const API_ME_Upload = @"/api/user/upload";

NSString *const API_ME_Sign = @"/api/my/sign";

NSString *const API_ME_Follows = @"/api/my/follows";

NSString *const API_ME_Orders = @"/api/my/actiOrders";

NSString *const API_ME_OrderDetails = @"/api/my/goodsOrderDetails";

NSString *const API_ME_UserAccountInfo = @"/api/my/userAccountInfo";

NSString *const API_ME_UpdateUserInfo = @"/api/user/updateUserInfo";

NSString *const API_ME_GetAddress = @"/api/my/getAddress";

NSString *const API_ME_Subscribe = @"/api/my/subscribe";

NSString *const API_ME_ProductList = @"/api/my/productList";

NSString *const API_ME_AddAddress = @"/api/my/addAddress";

NSString *const API_ME_UpdateAddress = @"/api/my/updateAddress";

NSString *const API_ME_Authentication = @"/api/my/authentication";

NSString *const API_ME_ProductDetails = @"/api/my/productDetails";

NSString *const API_ME_Buy = @"/api/my/buy";

NSString *const API_ME_SignToday = @"/api/my/signToday";

NSString *const API_ME_BindingTel = @"/api/user/bindingTel";

NSString *const API_ME_SignRules = @"/api/user/signRules";

NSString *const API_ME_FreeBack = @"/api/user/feedBack";

NSString *const API_ME_GoodsOrders = @"/api/my/goodsOrders";

NSString *const API_ME_ConfirmReceipt = @"/api/my/confirmReceipt";

NSString *const API_ME_WithdrawCash = @"/api/my/withdrawCash";

NSString *const API_ME_Refund = @"/api/my/refund";

NSString *const API_ME_BuyGood = @"/api/my/buyGood";

NSString *const API_ME_GetMsgCount = @"/api/home/getMsgCount";

NSString *const API_ME_BuyVideo = @"/api/my/buyVideo";

NSString *const API_ME_GetUserStatus = @"/api/user/getUserStatus";

NSString *const API_ME_GetStartPage = @"/api/home/getStartPage";
#pragma mark -

#pragma mark - Pay
NSString *const API_Order_CreatOrderInfo = @"/api/my/createOrder";

NSString *const API_Order_ApplePay_CreatOrderInfo = @"/api/my/applePay";

NSString *const API_Order_ApplePay_CallBack = @"/api/my/appleHandle";

NSString *const API_Order_WalletPay = @"/api/my/balancePay";
#pragma mark -

@end
