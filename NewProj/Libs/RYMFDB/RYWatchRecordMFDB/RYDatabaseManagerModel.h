//
//  RYDatabaseManagerModel.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYDatabaseManagerModel : NSObject

//标记
@property(nonatomic, strong)NSNumber *index;

/**
 *  @brief  封面
 */
@property (copy, nonatomic) NSString *uuid;
/**
 *  @brief  封面
 */
@property (copy, nonatomic) NSString *cover;

/**
 *  @brief  视频id
 */
@property (copy, nonatomic) NSString *videoId;

/**
 *  @brief  视频地址
 */
@property (copy, nonatomic) NSString *url;

/**
 *  @brief  是否收费，0-免费  1-收费 2-VIP 3导师
 */
@property (copy, nonatomic) NSString *isFree;

/**
 *  @brief  是否已购买
 */
@property (copy, nonatomic) NSString *isBuy;

/**
 *  @brief  视频时长
 */
@property (copy, nonatomic) NSString *duration;

/**
 *  @brief  视频播放时长
 */
@property (copy, nonatomic) NSString *videoTime;

/**
 *  @brief  广告地址url
 */
@property (copy, nonatomic) NSString *advertisementUrl;

/**
 *  @brief  视频标题
 */
@property (copy, nonatomic) NSString *title;

/**
 *  @brief  视频类别
 */
@property (copy, nonatomic) NSString *summary;

/**
 *  @brief  课程id
 */
@property (copy, nonatomic) NSString *courseId;

/**
 *  @brief  价格
 */
@property (copy, nonatomic) NSString *price;

@end
