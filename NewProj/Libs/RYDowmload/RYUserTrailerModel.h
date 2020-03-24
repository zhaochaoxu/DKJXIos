//
//  RYUserTrailerModel.h
//  HRRongYaoApp
//
//  Created by Mac on 2017/6/5.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RYUserTrailerModel : JSONModel

@property (copy, nonatomic) NSString *activitieId;
@property (copy, nonatomic) NSString *beginTime;
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *summary;
@end
