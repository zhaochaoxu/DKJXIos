//
//  RYApiTool.h
//  HRRongYaoApp
//
//  Created by 胡贝贝 on 2017/5/18.
//  Copyright © 2017年 fabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYApiTool : NSObject

//获取好友列表
+ (void)GetMyFridensWithPage:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSArray *msg))success
                     failure:(void (^)(NSString *errormsg))fail;

//添加 删除 拒绝 同意好友的操作
+ (void)RYmanageFriendsWithType:(NSString *)type
                           imId:(NSString *)imId
                        success:(void (^)(NSInteger msg))success
                        failure:(void (^)(NSString *errormsg))fail;

//获取我的群列表
+ (void)RYGetMyGroupWithPage:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSArray *msg))success
                     failure:(void (^)(NSString *errormsg))fail;

//申请/退出//修改群信息/解散群
+ (void)RYManageMyGroupWithType:(NSString *)type
                        groupId:(NSString *)groupId
                      groupName:(NSString *)groupName
                   groupSummary:(NSString *)groupSummary
                  groupClassify:(NSString *)groupClassify
                      isPrivate:(NSString *)isPrivate
                        success:(void (^)(NSInteger msg))success
                        failure:(void (^)(NSString *errormsg))fail;

//创建普通群
+ (void)RYCreateNormalGroupWithGroupName:(NSString *)groupName
                            groupSummary:(NSString *)groupSummary
                           groupClassify:(NSString *)groupClassify
                               isPrivate:(BOOL )isPrivate
                                  member:(NSString *)member
                                 success:(void (^)(NSString *msg))success
                                 failure:(void (^)(NSString *errormsg))fail;

//获取群组类别
+ (void)RYGetGroupClassifyWithSuccess:(void (^)(NSArray *msg))success
                              failure:(void (^)(NSString *errormsg))fail;

//获取图书馆
+ (void)RYGetLibraryWithID_C:(NSString *)ID_C
                        page:(NSString *)page
                       limit:(NSString *)limit
                     success:(void (^)(NSDictionary *msg))success
                     failure:(void (^)(NSString *errormsg))fail;

//获取家教室
+ (void)RYGetInvitedTutorWithPage:(NSString *)page
                              gid:(NSString *)gid
                            limit:(NSString *)limit
                          success:(void (^)(NSArray *msg))success
                          failure:(void (^)(NSString *errormsg))fail;

//搜索群
+ (void)RYSearchGroupsWithContent:(NSString *)content
                          page:(NSString *)page
                         limit:(NSString *)limit
                       success:(void (^)(NSArray *msg))success
                       failure:(void (^)(NSString *errormsg))fail;

//公共群列表
+ (void)RYGetPublicGroupsWithPage:(NSString *)page
                         limit:(NSString *)limit
                       success:(void (^)(NSArray *msg))success
                       failure:(void (^)(NSString *errormsg))fail;

//id获取群详情
+ (void)RYGetGroupsDetailWithGroupId:(NSString *)groupId
                             success:(void (^)(NSDictionary *msg))success
                             failure:(void (^)(NSString *errormsg))fail;

//获取全平台所有好友
+ (void)RYGetAllRegisterWithPage:(NSString *)page
                           limit:(NSString *)limit
                        nickname:(NSString *)nickname
                         success:(void (^)(NSArray *msg))success
                         failure:(void (^)(NSString *errormsg))fail;

//验证通讯录
+ (void)RYGetAddressListFriendsWithtel:(NSString *)tel
                               success:(void (^)(NSArray *msg))success
                               failure:(void (^)(NSString *errormsg))fail;

//查询新的朋友
+ (void)RYGetNewsFriendsWithPage:(NSString *)page
                           limit:(NSString *)limit
                         success:(void (^)(NSArray *msg))success
                         failure:(void (^)(NSString *errormsg))fail;

//邀请好友
+ (void)RYinviteFriendWithTel:(NSString *)tel
                      success:(void (^)(NSInteger msg))success
                      failure:(void (^)(NSString *errormsg))fail;


//加人踢人
+ (void)RYManagerMembersWithGroupUid:(NSString *)groupUid
                                Type:(NSString *)type
                             groupId:(NSString *)groupId
                              member:(NSString *)member
                             success:(void (^)(NSInteger msg))success
                             failure:(void (^)(NSString *errormsg))fail;


//搜索群
+ (void)RYSearchFriendsWithName:(NSString *)name
                        success:(void (^)(NSArray *msg))success
                        failure:(void (^)(NSString *errormsg))fail;


//获取空间图书馆
+ (void)RYGetAttachmentWithGroupId:(NSString *)groupId
                              Page:(NSString *)page
                             limit:(NSString *)limit
                           success:(void (^)(NSArray *msg))success
                           failure:(void (^)(NSString *errormsg))fail;




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
                       failure:(void (^)(NSString *errormsg))fail;

//群文件下载
//+ (void)RYGroupFileWithGroupId:(NSString *)groupId
//                          type:(NSString *)type
//                          name:(NSString *)name
//                      fileType:(NSString *)fileType
//                           aid:(NSString *)aid
//                      progress:(void (^)(NSProgress *progress))progressBlock
//                       success:(void (^)(NSInteger msg))success
//                       failure:(void (^)(NSString *errormsg))fail;

//上传传图片

+ (void)RYUploadFileWithType:(NSString *)type
                     groupId:(NSString *)groupId
                        name:(NSString *)name
                    fileType:(NSString *)fileType
                        file:(UIImage *)image
                    progress:(void (^)(NSProgress *progress))progressBlock
                     success:(void (^)(NSInteger msg))success
                     failure:(void (^)(NSString *errormsg))fail;


//上传视频
+ (void)RYUploadVideoWithType:(NSString *)type
                      groupId:(NSString *)groupId
                         name:(NSString *)name
                     fileType:(NSString *)fileType
                         file:(NSURL *)file
                     progress:(void (^)(NSProgress *progress))progressBlock
                      success:(void (^)(NSInteger msg))success
                      failure:(void (^)(NSString *errormsg))fail;

//下载
+ (void)RYDownloadImageVideoUrl:(NSString *)url
                       didWriteData:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))didWriteData
                       progress:(void (^)(NSProgress *progress))progressBlock
                        success:(void (^)(NSURL *msg))success
                        failure:(void (^)(NSString *errormsg))fail;
//downloadTaskWithURLString

+ (BOOL)isReachable:(UIView *)view;


@end
