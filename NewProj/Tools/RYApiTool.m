//
//  RYApiTool.m
//  HRRongYaoApp
//
//  Created by 胡贝贝 on 2017/5/18.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import "RYApiTool.h"

@implementation RYApiTool

+ (void)GetMyFridensWithPage:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSArray *msg))success
                     failure:(void (^)(NSString *errormsg))fail;
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"page":page,
                               @"limit":limit
                               };
    
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/friends"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
        
                                     }];
}

//添加 删除 拒绝 同意好友的操作
+ (void)RYmanageFriendsWithType:(NSString *)type
                           imId:(NSString *)imId
                        success:(void (^)(NSInteger msg))success
                        failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"type":type,
                               @"imId":imId
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/updateFriend"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         success(responseObject.errorCode);
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//获取我的群列表
+ (void)RYGetMyGroupWithPage:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSArray *msg))success
                     failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"page":page,
                               @"limit":limit
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/groups"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//申请/退出//修改群信息/解散群
+ (void)RYManageMyGroupWithType:(NSString *)type
                        groupId:(NSString *)groupId
                      groupName:(NSString *)groupName
                   groupSummary:(NSString *)groupSummary
                  groupClassify:(NSString *)groupClassify
                      isPrivate:(NSString *)isPrivate
                        success:(void (^)(NSInteger msg))success
                        failure:(void (^)(NSString *errormsg))fail;
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = nil;
    if ([type isEqual:@"2"]) {
        postDict = @{@"c":uid,
                     @"type":type,
                     @"groupId":groupId,
                     };
    }else if ([type isEqual:@"3"]){//三是解散群
        postDict = @{@"c":uid,
                     @"type":type,
                     @"groupId":groupId,
                     };
    }else if([type isEqual:@"4"]){
        if (groupName) {
            postDict = @{@"c":uid,
                         @"type":type,
                         @"groupId":groupId,
                         @"groupName":groupName
                         };
        }else if (groupSummary){
            postDict = @{@"c":uid,
                         @"type":type,
                         @"groupId":groupId,
                         @"groupSummary":groupSummary
                         };
        }else if (groupClassify){
            postDict = @{@"c":uid,
                         @"type":type,
                         @"groupId":groupId,
                         @"groupClassify":groupClassify
                         };
        }else if (isPrivate){
            postDict = @{@"c":uid,
                         @"type":type,
                         @"groupId":groupId,
                         @"isPrivate":isPrivate
                         };
        }

    }else if ([type isEqual:@"1"]){
        postDict = @{@"c":uid,
                     @"type":type,
                     @"groupId":groupId,
                     };
    }
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/updateGroups"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.errorCode == 200) {
                                             success(responseObject.errorCode);
                                         }
                                         success(responseObject.errorCode);

                                     } failure:^(NSError *error) {
                                         NSLog(@"1");
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//创建普通群
+ (void)RYCreateNormalGroupWithGroupName:(NSString *)groupName
                            groupSummary:(NSString *)groupSummary
                           groupClassify:(NSString *)groupClassify
                               isPrivate:(BOOL )isPrivate
                                  member:(NSString *)member
                                 success:(void (^)(NSString *msg))success
                                 failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict;
    if (member == nil||member == NULL||[member  isEqual: @""]) {
        postDict = @{@"c":uid,
                     @"groupName":groupName,
                     @"groupSummary":groupSummary,
                     @"groupClassify":groupClassify,
                     @"isPrivate":@(isPrivate),
                   
                     };
    }else{
        postDict = @{@"c":uid,
                     @"groupName":groupName,
                     @"groupSummary":groupSummary,
                     @"groupClassify":groupClassify,
                     @"isPrivate":@(isPrivate),
                     @"member":member
                     };
    }
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/createGroups"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.errorMsg);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//获取群组类别
+ (void)RYGetGroupClassifyWithSuccess:(void (^)(NSArray *msg))success
                              failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/groupClassify"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//获取图书馆
+ (void)RYGetLibraryWithID_C:(NSString *)ID_C
                        page:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSDictionary *msg))success
                     failure:(void (^)(NSString *errormsg))fail
{
    NSDictionary *postDict = @{@"ID_C":ID_C,
                               @"page":page,
                               @"limit":limit
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/attachment"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//获取家教室
+ (void)RYGetInvitedTutorWithPage:(NSString *)page
                              gid:(NSString *)gid
                            limit:(NSString *)limit
                          success:(void (^)(NSArray *msg))success
                          failure:(void (^)(NSString *errormsg))fail;
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"gid":gid,
                               @"page":page,
                               @"limit":limit
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/invitedTutor"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
//                                         NSLog(@"jiajiaoshi=%@",responseObject.data);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//搜索群
+ (void)RYSearchGroupsWithContent:(NSString *)content
                             page:(NSString *)page
                            limit:(NSString *)limit
                          success:(void (^)(NSArray *msg))success
                          failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"content":content,
                               @"page":page,
                               @"limit":limit
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/searchGroup"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }

                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//公共群列表
+ (void)RYGetPublicGroupsWithPage:(NSString *)page
                            limit:(NSString *)limit
                          success:(void (^)(NSArray *msg))success
                          failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"page":page,
                               @"limit":limit
                               };
    
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/getPublicGroup"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
    
}

//id获取群详情
+ (void)RYGetGroupsDetailWithGroupId:(NSString *)groupId
                             success:(void (^)(NSDictionary *msg))success
                             failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"groupId":groupId,
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/getGroupByGid"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         fail(RYNetworkError);
                                     }];
}

//获取全平台所有好友
+ (void)RYGetAllRegisterWithPage:(NSString *)page
                           limit:(NSString *)limit
                        nickname:(NSString *)nickname
                         success:(void (^)(NSArray *msg))success
                         failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict;
    if (nickname == nil || nickname == NULL) {
        postDict = @{@"c":uid,
                     @"page":page,
                     @"limit":limit
                     };
        
    }else{
        postDict = @{@"c":uid,
                     @"page":page,
                     @"limit":limit,
                     @"nickname":nickname
                     };
    }

    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/allUsersList"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//验证通讯录
+ (void)RYGetAddressListFriendsWithtel:(NSString *)tel
                               success:(void (^)(NSArray *msg))success
                               failure:(void (^)(NSString *errormsg))fail;
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"tel":tel
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/addressListFriends"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//查询新的朋友
+ (void)RYGetNewsFriendsWithPage:(NSString *)page
                           limit:(NSString *)limit
                         success:(void (^)(NSArray *msg))success
                         failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"page":page,
                               @"limit":limit
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/newFriends"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//邀请好友
+ (void)RYinviteFriendWithTel:(NSString *)tel
                      success:(void (^)(NSInteger msg))success
                      failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"tel":tel
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/inviteFriend"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.errorCode) {
                                             success(responseObject.errorCode);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         if (error) {
                                             fail(RYNetworkError);
                                         }
                                     }];
}

//加人踢人
+ (void)RYManagerMembersWithGroupUid:(NSString *)groupUid
                                Type:(NSString *)type
                             groupId:(NSString *)groupId
                              member:(NSString *)member
                             success:(void (^)(NSInteger msg))success
                             failure:(void (^)(NSString *errormsg))fail;
{

    NSDictionary *postDict = @{@"c":groupUid,
                               @"type":type,
                               @"groupId":groupId,
                               @"member":member
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/groupMember"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.errorCode) {
                                             success(responseObject.errorCode);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//搜好友
+ (void)RYSearchFriendsWithName:(NSString *)name
                        success:(void (^)(NSArray *msg))success
                        failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"name":name
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/searchFriends"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//获取空间图书馆
+ (void)RYGetAttachmentWithGroupId:(NSString *)groupId
                              Page:(NSString *)page
                             limit:(NSString *)limit
                           success:(void (^)(NSArray *msg))success
                           failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSString *groupid = [NSString stringWithFormat:@"%@",groupId];
    NSDictionary *postDict = @{@"c":uid,
                               @"gid":groupid,
                               @"page":page,
                               @"limit":limit
                               };
    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/attachment"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         if (responseObject.data) {
                                             
                                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:groupId];//删除
                                             [[NSUserDefaults standardUserDefaults] setValue:responseObject.data forKey:groupid];//替换最新的
                                             
                                             success(responseObject.data);
                                         }
                                         
                                     } failure:^(NSError *error) {
                                         NSArray *list = [[NSUserDefaults standardUserDefaults] valueForKey:groupid];
                                         if ([list count]) {
                                             success(list);
                                         }else{
                                             fail(error.localizedDescription);
                                         }
                                     }];
}


//群文件上传下载
+ (void)RYGroupFileWithGroupId:(NSString *)groupId
                          type:(NSString *)type
                          name:(NSString *)name
                           url:(NSString *)url
                       storage:(NSString *)storage
                      fileType:(NSString *)fileType
                           aid:(NSString *)aid
                      progress:(void (^)(NSProgress *progress))progressBlock
                       success:(void (^)(NSInteger msg))success
                       failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict;
    if ([type isEqual:@"1"]) {
       postDict = @{@"c":uid,
                    @"groupId":groupId,
                    @"type":type,
                    @"name":name,
                    @"url":url,
                    @"storage":storage,
                    @"fileType":fileType

                    };
    }else if ([type isEqual:@"2"]){
        postDict = @{@"c":uid,
                     @"groupId":groupId,
                     @"type":type,
                     @"name":name,
                     @"fileType":fileType,
                     @"aid":aid
                     };
    }

    [[XYHTTPRequestManager shareInstance]POST:@"/api/family/groupFile"
                                   parameters:postDict
                                     progress:^(NSProgress *uploadProgress) {
                                         progressBlock(uploadProgress);
                                     } success:^(XYResponseObject *responseObject) {
                                         NSLog(@"%@",responseObject);
                                         success(responseObject.errorCode);
                                         
                                     } failure:^(NSError *error) {
                                         
                                     }];
}

//上传传图片
+ (void)RYUploadFileWithType:(NSString *)type
                       image:(UIImage *)image
                    progress:(void (^)(NSProgress *progress))progressBlock
                     success:(void (^)(NSDictionary *msg))success
                     failure:(void (^)(NSString *errormsg))fail
{
    NSDictionary *postDict = @{@"type":type
                               };
    
//    [[XYHTTPRequestManager shareInstance] POST:@"/api/user/upload"
//                                    parameters:postDict
//                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//                         [RYUtils fixedUploadImages:image completion:^(NSData *data, NSString *fileName, NSString *mimeType) {
//                             [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
//                         }];
//
//                     } progress:^(NSProgress *uploadProgress) {
//                         progressBlock(uploadProgress);
//                     } success:^(XYResponseObject *responseObject) {
//                         if (responseObject.status == XYRequestStatusSuccessed) {
//                             success(responseObject.data);
//                         }
//                     } failure:^(NSError *error) {
//
//                     }];
}

+ (void)RYUploadFileWithType:(NSString *)type
                     groupId:(NSString *)groupId
                        name:(NSString *)name
                    fileType:(NSString *)fileType
                        file:(UIImage *)image
                    progress:(void (^)(NSProgress *progress))progressBlock
                     success:(void (^)(NSInteger msg))success
                     failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"type":type,
                               @"groupId":groupId,
                               @"name":name,
                               @"fileType":fileType,
                               };
    
//    [[XYHTTPRequestManager shareInstance] POST:@"/api/family/groupFile"
//                                    parameters:postDict
//                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//                         [RYUtils fixedUploadImages:image completion:^(NSData *data, NSString *fileName, NSString *mimeType) {
//                             [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
//                         }];
//
//                     } progress:^(NSProgress *uploadProgress) {
//                         progressBlock(uploadProgress);
//                     } success:^(XYResponseObject *responseObject) {
//                         if (responseObject.status == XYRequestStatusSuccessed) {
//                             success(responseObject.errorCode);
//                         }
//                     } failure:^(NSError *error) {
//
//                     }];
}

//上传视频
//+ (void)RYUploadFileWithType:(NSString *)type
//                        file:(NSURL *)file
//                    progress:(void (^)(NSProgress *progress))progressBlock
//                     success:(void (^)(NSDictionary *msg))success
//                     failure:(void (^)(NSString *errormsg))fail
//{
//    NSDictionary *postDict = @{@"type":type
//                               };
//    
//    [[XYHTTPRequestManager shareInstance] POST:@"/api/user/upload"
//                                    parameters:postDict
//                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                         
//                         NSData *data = [NSData dataWithContentsOfURL:file];
//                         NSString *urlstr = [file lastPathComponent];
//
//                         //上传的参数(上传图片，以文件流的格式)
//                         [formData appendPartWithFileData:data
//                                                     name:@"file"
//                                                 fileName:[NSString stringWithFormat:@"%@",urlstr]
//                                                 mimeType:@"video/mp4"];
//                         
//                     } progress:^(NSProgress *uploadProgress) {
//                         progressBlock(uploadProgress);
//                     } success:^(XYResponseObject *responseObject) {
//                         if (responseObject.status == XYRequestStatusSuccessed) {
//                             success(responseObject.data);
//                         }
//                     } failure:^(NSError *error) {
//                         
//                     }];
//}

+ (void)RYUploadVideoWithType:(NSString *)type
                      groupId:(NSString *)groupId
                         name:(NSString *)name
                     fileType:(NSString *)fileType
                         file:(NSURL *)file
                     progress:(void (^)(NSProgress *progress))progressBlock
                      success:(void (^)(NSInteger msg))success
                      failure:(void (^)(NSString *errormsg))fail
{
    NSString *uid = [RYUserInfo uid];
    NSDictionary *postDict = @{@"c":uid,
                               @"type":type,
                               @"groupId":groupId,
                               @"name":name,
                               @"fileType":fileType,
                               };
    [[XYHTTPRequestManager shareInstance] POST:@"/api/family/groupFile"
                                    parameters:postDict
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         NSData *data = [NSData dataWithContentsOfURL:file];
                         NSString *urlstr = [file lastPathComponent];
                         
                         //上传的参数(上传图片，以文件流的格式)
                         [formData appendPartWithFileData:data
                                                     name:@"file"
                                                 fileName:urlstr
                                                 mimeType:@"video/mp4"];
                         
                     } progress:^(NSProgress *uploadProgress) {
                         progressBlock(uploadProgress);
                     } success:^(XYResponseObject *responseObject) {
                         if (responseObject.status == XYRequestStatusSuccessed) {
                             success(responseObject.errorCode);
                         }
                     } failure:^(NSError *error) {
                         
                     }];
}


+ (void)RYDownloadImageVideoUrl:(NSString *)url
                   didWriteData:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))didWriteData
                       progress:(void (^)(NSProgress *progress))progressBlock
                        success:(void (^)(NSURL *msg))success
                        failure:(void (^)(NSString *errormsg))fail
{

     [[XYHTTPRequestManager shareInstance] downloadTaskWithURLString:url
                                                         parameters:nil
                                                      didWriteData:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                                                          didWriteData(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
//                                                        double process = (double)totalBytesWritten / totalBytesExpectedToWrite;
//                                                          rateByte(process);
                                                        } progress:^(NSProgress *progress) {
                                                            progressBlock(progress);
                                                         } success:^(NSURL *fileURL) {
                                                             NSLog(@"%@",fileURL);
                                                             success(fileURL);
                                                             
                                                         } failure:^(NSError *error) {
    
                                                         }];
}

+ (BOOL)isReachable:(UIView *)view{
    BOOL status = [XYHTTPRequestManager shareInstance].isReachable;
    if (!status) {
        [view makeToast:RYNetworkError];
    }
    return status;
}
@end
