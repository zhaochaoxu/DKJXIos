//
//  RYUserInfo.m
//  HRRongYaoApp
//
//  Created by Mac on 2017/5/17.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYUserInfo.h"


NSString *const RYUserSetUpIsPlayOnWiFiKey = @"RYUserSetUpIsPlayOnWiFiKey";
NSString *const RYUserSetUpIsDownOnWiFiKey = @"RYUserSetUpIsDownOnWiFiKey";

@implementation RYUserInfo


+ (void)addValue:(id)value forKey:(NSString *)key
{
    [HTSaveCachesFile saveDataList:value fileName:key];
}

+ (NSString *)birthday
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"birthday"]];
}

+ (NSString *)idCard
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"idCard"]];
}

+ (NSString *)fans
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"fans"]];
}

+ (NSString *)follows
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"follows"]];
}


+ (NSString *)honourBalance
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"honourBalance"]];
}

+ (NSString *)honourCurrency
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"honourCurrency"]];
}

+ (NSString *)honourDiamonds
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"honourDiamonds"]];
}

+ (NSString *)uid
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"uid"]];
}

+ (NSString *)imId
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"imId"]];
}

+ (NSString *)imPwd
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"imPwd"]];
}

+ (NSString *)isReal
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"isReal"]];
}

+ (NSString *)liveNum
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"liveNum"]];
}

+ (NSString *)mytags
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"mytags"]];
}

+ (NSString *)nickname
{
    if ([RYUserInfo type].integerValue == 1) {
        return [RYUserInfo realName];
    }
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"nickname"]];
}

+ (NSString *)tel
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"tel"]];
}

+ (NSString *)price
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"price"]];
}

+ (NSString *)qrcode
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"qrcode"]];
}

+ (NSString *)realName
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"realName"]];
}

+ (NSString *)registerCity
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"registerCity"]];
}

+ (NSString *)sex
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"sex"]];
}

+ (NSString *)sign
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"sign"]];
}

+ (NSString *)status
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"status"]];
}

+ (NSString *)tags
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"tags"]];
}

+ (NSString *)type
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"type"]];
}

+ (NSString *)userIcon
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"userIcon"]];
}

+ (NSString *)username
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"username"]];
}

+ (NSString *)videoNum
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"videoNum"]];
}

+ (NSString *)vip
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"vip"]];
}

+ (NSString *)vipTime
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"vipTime"]];
}

+ (NSString *)wxAccount
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"wxAccount"]];
}

+ (NSString *)zfbAccount
{
    return [NSString stringWithFormat:@"%@", [HTSaveCachesFile loadDataList:@"zfbAccount"]];
}

+ (NSString *)serverTel
{
    return [NSString stringWithFormat:@"%@",[HTSaveCachesFile loadDataList:@"serverTel"]];
}

+ (void)EmptyUserInfo
{
    [HTSaveCachesFile removeFile:@"birthday"];
    [HTSaveCachesFile removeFile:@"idCard"];
    [HTSaveCachesFile removeFile:@"fans"];
    [HTSaveCachesFile removeFile:@"follows"];
    [HTSaveCachesFile removeFile:@"honourBalance"];
    [HTSaveCachesFile removeFile:@"honourCurrency"];
    [HTSaveCachesFile removeFile:@"honourDiamonds"];
    [HTSaveCachesFile removeFile:@"uid"];
    [HTSaveCachesFile removeFile:@"imId"];
    [HTSaveCachesFile removeFile:@"imPwd"];
    [HTSaveCachesFile removeFile:@"isReal"];
    [HTSaveCachesFile removeFile:@"liveNum"];
    [HTSaveCachesFile removeFile:@"mytags"];
    [HTSaveCachesFile removeFile:@"nickname"];
    [HTSaveCachesFile removeFile:@"tel"];
    [HTSaveCachesFile removeFile:@"price"];
    [HTSaveCachesFile removeFile:@"qrcode"];
    [HTSaveCachesFile removeFile:@"realName"];
    [HTSaveCachesFile removeFile:@"registerCity"];
    [HTSaveCachesFile removeFile:@"sex"];
    [HTSaveCachesFile removeFile:@"sign"];
    [HTSaveCachesFile removeFile:@"status"];
    [HTSaveCachesFile removeFile:@"tags"];
    [HTSaveCachesFile removeFile:@"type"];
    [HTSaveCachesFile removeFile:@"userIcon"];
    [HTSaveCachesFile removeFile:@"username"];
    [HTSaveCachesFile removeFile:@"videoNum"];
    [HTSaveCachesFile removeFile:@"vip"];
    [HTSaveCachesFile removeFile:@"vipTime"];
    [HTSaveCachesFile removeFile:@"wxAccount"];
    [HTSaveCachesFile removeFile:@"zfbAccount"];
    [HTSaveCachesFile removeFile:@"serverTel"];
}


+ (BOOL)canStartLive {
    return [[RYUserInfo isReal] boolValue] || [[RYUserInfo type] boolValue];
}

+ (void)userIsRealWithAuthorized:(void(^)())authorized
                        ordinary:(void(^)(NSInteger isReal))ordinary
                          mentor:(void(^)())mentor {
    if ([[RYUserInfo type] boolValue]) {
        RYSafeBlock(mentor, nil);
    }else{
        NSInteger isReal = [RYUserInfo isReal].integerValue;
        switch (isReal) {
            case 0:{
                RYSafeBlock(authorized, nil);
            }break;
            case 1:
            case 2:
            case 5:{
                RYSafeBlock(ordinary, isReal);
            }break;
        }
    }
}

@end
