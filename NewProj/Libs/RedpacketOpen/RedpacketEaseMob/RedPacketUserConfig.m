//
//  YZHUserConfig.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/3/8.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketUserConfig.h"
#import "UserProfileManager.h"
#import "RPRedpacketBridge.h"
#import "RPRedpacketUnionHandle.h"
#import "ChatDemoHelper.h"
#import "RPRedpacketConstValues.h"

#define REDPACKET_CMD_MESSAGE   @"refresh_red_packet_ack_action"

/** 环信IMToken过期 */
NSInteger const RedpacketEaseMobTokenOutDate = 20304;

static RedPacketUserConfig *__sharedConfig__ = nil;

@interface RedPacketUserConfig () <EMClientDelegate,
                                    EMChatManagerDelegate,
                                    RPRedpacketBridgeDelegate>
{
    /** 环信商户APPKey*/
    NSString *_dealerAppKey;
    /** 是否已经注册了消息代理, 重复注册会导致消息重复接收 */
    BOOL _isRegeistMessageDelegate;
}

@end


@implementation RedPacketUserConfig

/** 获取聊天消息和Cmd消息*/
- (void)beginObserveMessage
{
    if (!_isRegeistMessageDelegate && [EMClient sharedClient].chatManager) {
        
        _isRegeistMessageDelegate = YES;
        /** 消息代理 */
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        
    }
}

- (void)removeObserver
{
    _isRegeistMessageDelegate = NO;
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self removeObserver];
}

+ (RedPacketUserConfig *)sharedConfig
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __sharedConfig__ = [[RedPacketUserConfig alloc] init];
        [RPRedpacketBridge sharedBridge].delegate = __sharedConfig__;
        [RPRedpacketBridge sharedBridge].isDebug = YES;//开发者调试的的时候，设置为YES，看得见日志。
        
    });
    
    /** 为了保证消息通知被注册 */
    [__sharedConfig__ beginObserveMessage];
    
    return __sharedConfig__;
}

- (void)configWithAppKey:(NSString *)appKey
{
    _dealerAppKey = appKey;
}

/** MARK:获取当前用户登陆信息*/
- (RPUserInfo *)redpacketUserInfo
{
    RPUserInfo *userInfo = [RPUserInfo new];
    userInfo.userID = [EMClient sharedClient].currentUsername;
    userInfo.userName = userInfo.userID;
    userInfo.userName = [RYUserInfo nickname];
    NSString *icon = [NSURL URLWithString:[RYUserInfo userIcon]].absoluteString;
    userInfo.avatar = icon;

    return userInfo;
}

/* MARK:红包Token注册回调**/
- (void)redpacketFetchRegisitParam:(RPFetchRegisitParamBlock)fetchBlock withError:(NSError *)error
{
    NSString *userToken = nil;
    BOOL isRefresh = error == nil ? NO : YES;
    EMClient *client = [EMClient sharedClient];
    SEL selector = NSSelectorFromString(@"getUserToken:");
    
    if ([client respondsToSelector:selector]) {
        
        IMP imp = [client methodForSelector:selector];
        NSString *(*func)(id, SEL, NSNumber *) = (void *)imp;
        userToken = func(client, selector, @(isRefresh));
        
    }
    
    if (userToken.length) {
        
        NSString *userId = self.redpacketUserInfo.userID;
        RPRedpacketRegisitModel *model = [RPRedpacketRegisitModel easeModelWithAppKey:_dealerAppKey
                                                                             appToken:userToken
                                                                         andAppUserId:userId];
        fetchBlock(model);
        
    }else {
        
        fetchBlock(nil);
        
    }

}

/** MARK:红包被抢消息处理*/
- (void)didReceiveMessages:(NSArray *)aMessages
{
    /** 收到红包被抢的 */
    [self handleMessage:aMessages];
}

-(void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    /** 收到红包被抢的消息 */
    [self handleCmdMessages:aCmdMessages];
}

/** 点对点红包，红包被抢的消息 */
- (void)handleMessage:(NSArray <EMMessage *> *)aMessages
{
    for (EMMessage *message in aMessages) {
        NSDictionary *dict = message.ext;
        if (dict) {
            AnalysisRedpacketModel *redpacketModel = [AnalysisRedpacketModel analysisRedpacketWithDict:message.ext andIsSender:[dict objectForKey:@"family_from_name"]];
//            NSString *currentUserID = [EMClient sharedClient].currentUsername;
            NSString *userName = [RYUserInfo nickname];
            BOOL isSender = [redpacketModel.sender.userName isEqualToString:userName];
            NSString *text;
            /** 当前用户是红包发送者 */
            if ([AnalysisRedpacketModel messageCellTypeWithDict:dict] == MessageCellTypeRedpaketTaken && isSender) {
//                text = [NSString stringWithFormat:@"%@领取了你的红包",redpacketModel.receiver.userName];
                text = [NSString stringWithFormat:@"%@领取了你的红包",[dict objectForKey:@"family_from_name"]];
            }
//            text = [NSString stringWithFormat:@"%@领取了你的红包",[dict objectForKey:@"family_to_name"]];
            if (text && text.length > 0) {
                EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
                message.body = body;
                /** 把相应数据更新到数据库 */
                [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
            }
        }
    }
}

/** 群红包，红包被抢的消息 */
- (void)handleCmdMessages:(NSArray <EMMessage *> *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        
        EMCmdMessageBody * body = (EMCmdMessageBody *)message.body;
        NSDictionary *dict = message.ext;
        if ([body.action isEqualToString:REDPACKET_CMD_MESSAGE]) {
            
//            NSString *currentUserID = [EMClient sharedClient].currentUsername;
            NSString *conversationId = [message.ext valueForKey:RedpacketKeyRedpacketCmdToGroup];
            
            AnalysisRedpacketModel *redpacketModel = [AnalysisRedpacketModel analysisRedpacketWithDict:message.ext
                                                                                           andIsSender:0];
            NSString *userName = [RYUserInfo nickname];
            if ([redpacketModel.sender.userName isEqualToString:userName]){
                /** 当前用户是红包发送者 */
                NSString *text = [NSString stringWithFormat:@"%@领取了你的红包",[dict objectForKey:@"family_from_name"]];
                EMTextMessageBody *body1 = [[EMTextMessageBody alloc] initWithText:text];
                EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:conversationId
                                                                              from:message.from
                                                                                to:conversationId
                                                                              body:body1
                                                                               ext:message.ext];
                textMessage.chatType = EMChatTypeGroupChat;
                textMessage.isRead = YES;
                /** 更新界面 */
                BOOL isCurrentConversation = [self.chatVC.conversation.conversationId isEqualToString:conversationId];
                
                if (self.chatVC && isCurrentConversation){
                    
                    /** 刷新当前聊天界面 */
                    [self.chatVC addMessageToDataSource:textMessage
                                               progress:nil];
                    /** 存入当前会话并存入数据库 */
                    [self.chatVC.conversation insertMessage:textMessage
                                                      error:nil];
                    
                }else {
                    
                    /** 插入数据库 */
                    ConversationListController *listVc = [ChatDemoHelper shareHelper].conversationListVC;
                    
                    if (listVc) {
                        
                        for (id <IConversationModel> model in [listVc.dataArray copy]) {
                            
                            EMConversation *conversation = model.conversation;
                            
                            if ([conversation.conversationId isEqualToString:textMessage.conversationId]) {
                                
                                [conversation insertMessage:textMessage error:nil];
                                
                            }
                            
                        }
                        
                        [listVc refresh];
                        
                    }else {
                        
                        [[EMClient sharedClient].chatManager importMessages:@[textMessage] completion:nil];
                        
                    }
                }
            }
        }
    }
}





@end
