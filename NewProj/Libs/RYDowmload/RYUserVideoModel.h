//
//  RYUserVideoModel.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/6/5.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RYUserVideoModel : JSONModel

@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *duration;
@property (copy, nonatomic) NSString *isFree;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *videoId;

/**
 *  @brief  类别名称
 */
@property (copy, nonatomic) NSString *typeName;

@end
