//
//  HBApiTool.m
//  NewProj
//
//  Created by 胡贝 on 2019/3/13.
//  Copyright © 2019年 胡贝. All rights reserved.
//

#import "HBApiTool.h"


@interface HBApiTool ()



@end

@implementation HBApiTool



+ (void)GetHomePictureWithPage:(NSInteger )page
                       success:(void(^)(NSArray *))success
                       failure:(void(^)(NSString *errormsg))failure {
    
    NSString *uid = [RYUserInfo uid];
  
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.operationQueue.maxConcurrentOperationCount = 3;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = responseSerializer;
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@p%ld.html",@"http://dili.bdatu.com/jiekou/main/",page];
    [manager GET:url
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
    
//        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSArray *data = [responseObject objectForKey:@"album"];
        if (success) {
            success(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.domain);
        }
    }];

    
}

+ (void)picBrowseGet:(NSInteger )urlNum
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    // 4.发送GET请求
    
   NSString *url = [NSString stringWithFormat:@"%@%ld.html",PICIDAPIURL,urlNum];
    [mgr GET:url
  parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        if (success) {
            success(json);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)GetStoryWithNum:(NSInteger )num
                success:(void(^)(NSString *))success
                failure:(void(^)(NSError *))failure {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    // 4.发送GET请求
    
    NSString *url = [NSString stringWithFormat:@"http://other.glassmarket.cn/fortuneapi/netxiaohua/netxiaohuaapi/?action=getxiaohuas&starts=1&ends=%ld&leibieid=9",num];
    [mgr GET:url
  parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSStringEncoding myEncoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSString *responseStr= [[NSString alloc]initWithData:responseObject encoding:myEncoding];
//        NSString *responseStr = [self utf8String: responseObject];
//        NSString *responseStr =[NSString stringWithUTF8String:[responseObject bytes]];

        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        if (success) {
            success(responseStr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GetRegionWithSuccess:(void(^)(NSArray *array))success
                     failure:(void(^)(NSError *error))failure {
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    // 4.发送GET请求
    
    NSString *url = [NSString stringWithFormat:@"%@/province/list",RYServiceAddress];
    [mgr GET:url
  parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        
        NSArray *data = [json objectForKey:@"data"];
        
        if (success) {
            success(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GetCuisineWithSuccess:(void(^)(NSArray *array))success
                      failure:(void(^)(NSError *error))failure{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    // 4.发送GET请求
    
    NSString *url = [NSString stringWithFormat:@"%@/cuisineType/list",RYServiceAddress];
    [mgr GET:url
  parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        
        NSArray *data = [json objectForKey:@"data"];
        
        if (success) {
            success(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GetMenuListWithLongitude:(NSString *)longitude
                        latitude:(NSString *)latitude
                       bussHubId:(NSString *)bussHubId
                   cuisineTypeID:(NSString *)cuisineTypeID
                          pageNO:(NSString *)pageNO
                         success:(void(^)(NSDictionary *dict))success
                         failure:(void(^)(NSError *error))failure{
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid;
    if (!dict) {
        userid = @"";
    }else{
        if ([dict objectForKey:@"id"] == nil) {
            
            userid = @"";
        }else{
            userid = [[dict objectForKey:@"id"] stringValue];
        }
        
    }
    
    
    NSDictionary *postDict ;
    if (bussHubId ==nil && cuisineTypeID == nil) {
       postDict = @{@"latitude":latitude,
                    @"longitude":longitude,
                    @"pageNO":pageNO,
                    @"consumerID":userid
                                   };
    
    }else{
        if (bussHubId ==nil ) {
            postDict = @{@"latitude":latitude,
                         @"longitude":longitude,
                         @"cuisineTypeID":cuisineTypeID,
                         @"bussHubId":@"",
                         @"pageNO":pageNO,
                         @"consumerID":userid
                         };
        }else if (cuisineTypeID == nil)
            postDict = @{@"latitude":latitude,
                         @"longitude":longitude,
                         @"bussHubId":bussHubId,
                         @"cuisineTypeID":@"",
                         @"pageNO":pageNO,
                         @"consumerID":userid
                         };
        NSLog(@"postdic== %@",postDict);
    }
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/merchant/list",RYServiceAddress];

    [mgr GET:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
        
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//         NSArray *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

//发送验证码
+ (void)GetVerifyCodeWithPhoneNumber:(NSString *)phoneNumber
                             success:(void(^)(BOOL data))success
                             failure:(void(^)(NSError *error))failure {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    // 4.发送GET请求
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/wj/sendMsg/%@",RYServiceAddress,phoneNumber];
    [mgr GET:url
  parameters:nil
    progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        
        BOOL data = [json objectForKey:@"success"];
        
        if (success) {
            success(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//注册

+ (void)PostRegisterWithNickname:(NSString *)nickname
                     phoneNumber:(NSString *)phoneNumber
                      verifyCode:(NSString *)verifyCode
                        password:(NSString *)password
                         success:(void (^)(NSDictionary * _Nonnull))success
                         failure:(void (^)(NSError * _Nonnull))failure {
    
    NSDictionary *postDict = @{@"consumer.tel":phoneNumber,
                               @"password":password,
                               @"consumer.nickname":nickname,
                               @"msgCode":verifyCode,
                               };
    
    NSLog(@"postdic == %@",postDict);
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/add",RYServiceAddress];

    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         //        NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
    
}



+ (void)GetUserInfoWithTel:(NSString *)tel
                  password:(NSString *)password
                 weChatUID:(NSString *)weChatUID
                  weChatNO:(NSString *)weChatNO
                       sex:(NSString *)sex
                   imgpath:(NSString *)imgpath
                  nickname:(NSString *)nickname
                   msgCode:(NSString *)msgCode
                   success:(void(^)(NSDictionary *array))success
                   failure:(void(^)(NSError *error))failure {
    
    //consumer.tel，password， consumer.weChatUID，consumer.sex，imgpath，consumer.nickname，msgCode
    
    NSDictionary *postDict = @{@"consumer.tel":tel,
                               @"password":password,
                               @"consumer.weChatUID":weChatUID,
                               @"sex":sex,
                               @"imgpath":imgpath,
                               @"consumer.nickname":nickname,
                               @"msgCode":msgCode,
                               @"weChatNO":weChatNO
                               };
    
    NSLog(@"postdic == %@",postDict);
    
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/consumerlogin",RYServiceAddress];

    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//        NSDictionary *data = [json objectForKey:@"data"];
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//个人信息设置
+ (void)PostModifyUserInfoWithNickname:(NSString *)nickname
                                  sex:(NSString *)sex
                                birth:(NSString *)birth
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure {
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    
    NSDictionary *postDict;
    if (sex == nil && birth == nil) {
        postDict = @{@"id":userid,
                     @"nickname":nickname,
                     };
    }else if (nickname == nil && birth == nil){
        postDict = @{@"id":userid,
                     @"sex":sex,
                     };
    }else if (nickname == nil && sex == nil){
        postDict = @{@"id":userid,
                     @"birth":birth,
                     };
    }
    NSLog(@"%@",postDict);

    
    
 
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/update",RYServiceAddress];
    
    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
    
    
}

//绑定手机号
+ (void)PostBindCellPhoneWithPhoneNum:(NSString *)tel
                              msgCode:(NSString *)msgCode
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    
    NSDictionary *postDict = @{@"id":userid,
                               @"tel":tel,
                               @"msgCode":msgCode
                               };

    NSLog(@"%@",postDict);
    
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;

    NSString *url = [NSString stringWithFormat:@"%@/consumer/update",RYServiceAddress];
    
    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         //         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)GetUserInfoWithsuccess:(void(^)(NSDictionary *dict))success
                       failure:(void(^)(NSError *error))failure {
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    if (userid == nil) {
        NSDictionary *dic = [dict objectForKey:@"data"];
        userid = [dic objectForKey:@"id"];
    }
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/detail/%@",RYServiceAddress,userid];
    
    [mgr  GET:url
   parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(data);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

//吃过的招牌菜
+ (void)GetSpecialityEatenWithSuccess:(void(^)(NSArray *array))success
                              failure:(void(^)(NSError *error))failure{
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"id":userid};

    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/dishlist",RYServiceAddress];
    
    [mgr  GET:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         NSArray *data = [json objectForKey:@"data"];
         
         if (success) {
             success(data);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

//想吃的招牌菜
+ (void)GetWantSpecialityWithSuccess:(void(^)(NSArray *array))success
                             failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"consumerID":userid};
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/merchant/queryByConsId",RYServiceAddress];
    
    [mgr  GET:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         NSArray *data = [json objectForKey:@"data"];
         
         if (success) {
             success(data);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)GetMechantDetailsWithMechantId:(NSString *)mechantId
                               success:(void(^)(NSDictionary *dict))success
                               failure:(void(^)(NSError *error))failure {
    
//    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
//    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/merchant/detail?id=%@",RYServiceAddress,mechantId];
    
    [mgr  GET:url
   parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(data);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)getAccessTokenWithRespCode: (NSString*)respCode
                          callback: (void(^) (RequestStatus, NSString *str))callback {
    
    
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] init];
    
    AFHTTPResponseSerializer* responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    responseSerializer.acceptableContentTypes = [NSSet setWithArray:
                                                 @[@"application/json", @"text/json", @"text/plain", @"text/html"]];
    
    manager.responseSerializer = responseSerializer;
    
    [manager GET: @"https://api.weixin.qq.com/sns/oauth2/access_token?"
      parameters: @{
                    @"appid" : @"wxefefa4067b6d2ad0",
                    @"secret" : @"ca41252add66ba416d012fecdc3cc364",
                    @"code" : respCode,
                    @"grant_type" : @"authorization_code"
                    }
        progress: nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             NSError* error;
             NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData: responseObject
                                                                      options: NSJSONReadingAllowFragments
                                                                        error: &error];
             
             if (error) {
//                 callback(RequestStatusJsonError,
//                          ARR_REQUESTSTATUS_MSG[RequestStatusJsonError + 2]);
                 
                 return ;
             }
             /*
              {
              "access_token" = "xxxxx";
              "expires_in" = 7200;
              openid = "xxxxx";
              "refresh_token" = "xxxxx";
              scope = "snsapi_userinfo";
              unionid = "xxxxx";
              }
              */
//             WechatUser* wechatUser = [[WechatUser alloc] initWithDict: jsonDict];
             
             // Save accesstoken and openid to userdefault
//             [[NSUserDefaults standardUserDefaults] setObject: wechatUser.accessToken
//                                                       forKey: KEY_WXACCESSTOKEN_USERDEFAULTS];
//             [[NSUserDefaults standardUserDefaults] setObject: wechatUser.openId
//                                                       forKey: KEY_WXOPENID_USERDEFAULTS];
             
//             callback(RequestStatusSuccess,
//                      ARR_REQUESTSTATUS_MSG[RequestStatusJsonError + 2]);
         }
         failure:^(NSURLSessionDataTask * task, NSError * error) {
//             callback(RequestStatusNetworkError,
//                      ARR_REQUESTSTATUS_MSG[RequestStatusNetworkError + 2]);
             
         }];
}



+ (void)PostWeiXinPayWithTotalPrice:(NSString *)totalPrice
                               body:(NSString *)body
                           trade_no:(NSString *)trade_no
                         consumerID:(NSString *)consumerID
                            success:(void(^)(NSDictionary *dict))success
                            failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"consumerID":userid,
                               @"totalPrice":totalPrice,
                               @"body":body,
                               @"trade_no":trade_no,
                               @"type":@"app"

                               };
    NSLog(@"%@",postDict);
    
    
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/wjpay/wechat/apppay",RYServiceAddress];
    
    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(data);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)PostCollectionLoveWithMerchantID:(NSString *)merchantID
                              consumerID:(NSString *)consumerID
                                 success:(void(^)(NSDictionary *dict))success
                                 failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"consumerID":userid,
                               @"merchantID":merchantID
                               };
    NSLog(@"%@",postDict);
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumerMerchant/add",RYServiceAddress];
    [mgr POST:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)PostCancelCollectionLoveWithMerchantID:(NSString *)merchantID
                                    consumerID:(NSString *)consumerID
                                       success:(void(^)(NSDictionary *dict))success
                                       failure:(void(^)(NSError *error))failure {
    
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"consumerID":userid,
                               @"merchantID":merchantID
                               };
    NSLog(@"%@",postDict);
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumerMerchant/delete",RYServiceAddress];
    [mgr GET:url
   parameters:postDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSError *error;
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
         //         NSDictionary *data = [json objectForKey:@"data"];
         
         if (success) {
             success(json);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
    
}

//查询
+ (void)GetQueryPaySuccessOrderWithID:(NSString *)consumerID
                              success:(void(^)(NSDictionary *dict))success
                              failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    
    NSDictionary *postDict = @{@"consumerID":userid};
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
//    http://124.204.45.69:6666/consumer/qrcode/{id}
    
    NSString *url = [NSString stringWithFormat:@"%@/wjpay/queryWJOrder",RYServiceAddress];
    [mgr GET:url
  parameters:postDict
    progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        //         NSDictionary *data = [json objectForKey:@"data"];

        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//查询会员是否过期
+ (void)GetMembershipExpiresWithCheckDate:(NSString *)checkDate
                                  success:(void(^)(NSDictionary *dict))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSDictionary *dict = [HTSaveCachesFile loadDataList:@"HBUSER"];
    NSString *userid = [[dict objectForKey:@"id"] stringValue];
    NSDictionary *postDict = @{@"consumerID":userid,
                               @"checkDate":checkDate
                               };
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.设置超时时间为10s
    mgr.requestSerializer.timeoutInterval = 10;
    
    NSString *url = [NSString stringWithFormat:@"%@/consumer/checkDate",RYServiceAddress];
    [mgr GET:url
  parameters:postDict
    progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr =  [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        // NSDictionary *data = [json objectForKey:@"data"];
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end








