//
//  ChatWithRedPacketViewController.m
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "RedPacketChatViewController.h"
#import "EaseRedBagCell.h"
#import "RedpacketTakenMessageTipCell.h"
#import "RedpacketViewControl.h"
#import <RPRedpacketModel.h>
#import "RedPacketUserConfig.h"
#import <RPUserInfo.h>
#import "RPRedpacketUnionHandle.h"
//#import "RedpacketOpenConst.h"
//#import "YZHRedpacketBridge.h"
#import <RPRedpacketBridge.h>
#import "ChatDemoHelper.h"
#import <Masonry.h>
#import "RYExitGroupTipsView.h"
#import "RYNormalGroupSetController.h"
#import "RPAdvertInfo.h"
#import "RYApiTool.h"

//#import "UserProfileManager.h"
//#import "UIImageView+WebCache.h"

/** 红包聊天窗口 */
#define REDPACKET_CMD_MESSAGE   @"refresh_red_packet_ack_action"
@interface RedPacketChatViewController () < EaseMessageCellDelegate,EaseMessageViewControllerDataSource>

@property (nonatomic,strong)RYExitGroupTipsView *groupTipsV;
@property (nonatomic,strong)UIView *alphaV;

@end

@implementation RedPacketChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /** 设置用户头像大小 */
    [[EaseRedBagCell appearance] setAvatarSize:40.f];
    /** 设置头像圆角 */
    [[EaseRedBagCell appearance] setAvatarCornerRadius:20.f];
    
    if ([self.chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        
        /** 红包按钮 */
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"红包"]
                                 highlightedImage:[UIImage imageNamed:@"红包"]
                                            title:@"红包"];
        
        if (self.conversation.type == EMConversationTypeChat) {
            [self.chatBarMoreView removeItematIndex: 1];
            [self.chatBarMoreView removeItematIndex: 1];
            [self.chatBarMoreView removeItematIndex: 1];
        }else if (self.conversation.type == EMConversationTypeGroupChat){
            [self.chatBarMoreView removeItematIndex: 1];
            [self.chatBarMoreView removeItematIndex: 2];
            [self.chatBarMoreView removeItematIndex: 2];

        }

    }

    [RedPacketUserConfig sharedConfig].chatVC = self;
    __weak __typeof(&*self)weakSelf = self;
    self.alphaV = [[UIView alloc] init];
    self.alphaV.alpha = 0.5;
    self.alphaV.hidden = YES;
    self.alphaV.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.alphaV];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
    [self.alphaV addGestureRecognizer:tapRecognizer];
    
    self.groupTipsV = [[RYExitGroupTipsView alloc] init];
    self.groupTipsV.option = ^(NSInteger num){
        if (num == 0) {
            [weakSelf exitPublicGroupData];
        }else if(num == 1){
            [weakSelf hideAction];
        }
    };
    [self.view addSubview:self.groupTipsV];
    

    [self.groupTipsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    [self.alphaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(KHeightS);
    }];
}

//退群
- (void)exitPublicGroupData
{
    if (![RYApiTool isReachable:self.view]) {
        return;
    }
    NSString *groupId;
    if ([self.groupDict objectForKey:@"gid"]) {
        groupId = [[self.groupDict objectForKey:@"gid"] stringValue];
    }else if ([self.groupDict objectForKey:@"id"]){
        groupId = [[self.groupDict objectForKey:@"id"] stringValue];
    }
    __weak __typeof(&*self)weakSelf = self;
    [RYApiTool RYManageMyGroupWithType:@"2"
                               groupId:groupId
                             groupName:nil
                          groupSummary:nil
                         groupClassify:nil
                             isPrivate:nil
                               success:^(NSInteger msg) {
                                   if (msg == 200) {
                                       [weakSelf.view makeToast:@"退群成功"];
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                       });
                                   }
                                   
                               } failure:^(NSString *errormsg) {
                                   
                               }];
}

- (void)hideAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alphaV.hidden = YES;
    });
    
    CGRect frame = self.groupTipsV.frame;
    frame.origin.y = KHeightS;
    
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.groupTipsV.frame = frame;
    }];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        if (self.groupType == RYPublicGroup) {
            self.alphaV.hidden = NO;
            [self exitGroupAction];
        }else if (self.groupType == RYGroup){
            RYNormalGroupSetController *groupSetingVc = [[RYNormalGroupSetController alloc] init];
            groupSetingVc.groupDict = self.groupDict;
            [self.navigationController pushViewController:groupSetingVc animated:YES];
        }

    }

    
}

- (void)exitGroupAction
{
    CGRect frame = self.groupTipsV.frame;
    frame.origin.y = KHeightS-100;
    
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.groupTipsV.frame = frame;
    }];
}

/** 根据userID获得用户昵称,和头像地址 */
- (RPUserInfo *)profileEntityWith:(NSString *)userId  ext:(NSDictionary *)ext
{
    
    
    RPUserInfo *userInfo = [RPUserInfo new];
    if ([ext objectForKey:@"family_from_name"]) {
        userInfo.userName = [ext objectForKey:@"family_from_name"];
    }
 
    if ([ext objectForKey:@"family_from_icon"]) {
        NSString *url = [NSURL URLWithString:[ext objectForKey:@"family_from_icon"]].absoluteString;
        userInfo.avatar = url;
    }
    userInfo.userID = userId;
    
    return userInfo;
}

/** 长时间按在某条Cell上的动作 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([object conformsToProtocol:NSProtocolFromString(@"IMessageModel")]) {
        id <IMessageModel> messageModel = object;
        
//        NSDictionary *ext = messageModel.message.ext;
        /** 如果是红包，则只显示删除按钮 */
        if ([AnalysisRedpacketModel messageCellTypeWithDict:messageModel.message.ext] == MessageCellTypeRedpaket) {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:EMMessageBodyTypeCmd];
            return NO;
        }else if ([AnalysisRedpacketModel messageCellTypeWithDict:messageModel.message.ext] == MessageCellTypeRedpaketTaken) {
            return NO;
        }
    }
    return [super messageViewController:viewController canLongPressRowAtIndexPath:indexPath];
}

/** 自定义红包Cell*/
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    MessageCellType type = [AnalysisRedpacketModel messageCellTypeWithDict:messageModel.message.ext];
    
    if (type == MessageCellTypeRedpaket) {
        
        /** 红包的卡片样式*/
        EaseRedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:[EaseRedBagCell cellIdentifierWithModel:messageModel]];
        
        if (!cell) {
            
            cell = [[EaseRedBagCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[EaseRedBagCell cellIdentifierWithModel:messageModel]
                                                   model:messageModel];
            
            cell.delegate = self;
            
        }
        
        cell.model = messageModel;
        
        return cell;
        
    }else if (type == MessageCellTypeRedpaketTaken) {
        
        /** XX人领取了你的红包的卡片样式*/
        RedpacketTakenMessageTipCell *cell =  [[RedpacketTakenMessageTipCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                  reuseIdentifier:nil];
        
        [cell configWithText:messageModel.text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    MessageCellType type = [AnalysisRedpacketModel messageCellTypeWithDict:messageModel.message.ext];
    
    if (type == MessageCellTypeRedpaket)    {
        
        return [EaseRedBagCell cellHeightWithModel:messageModel];
        
    }else if (type == MessageCellTypeRedpaketTaken) {
        
        return [RedpacketTakenMessageTipCell heightForRedpacketMessageTipCell];
        
    }
    
    return 0;
}

/** 未读消息回执 */
- (BOOL)messageViewController:(EaseMessageViewController *)viewController shouldSendHasReadAckForMessage:(EMMessage *)message read:(BOOL)read
{
    if ([AnalysisRedpacketModel messageCellTypeWithDict:message.ext] != MessageCellTypeUnknown) {
        
        return YES;
        
    }
    
    return [super shouldSendHasReadAckForMessage:message read:read];
}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    
    RPRedpacketControllerType  redpacketVCType;
    RPUserInfo *userInfo = [RPUserInfo new];
    NSArray *groupArray = [EMGroup groupWithId:self.conversation.conversationId].occupants;
    
    if (self.conversation.type == EMConversationTypeChat) {
        
        /** 小额随机红包*/
        redpacketVCType = RPRedpacketControllerTypeRand;
        userInfo = [self profileEntityWith:self.conversation.conversationId ext:nil];
        
    }else {
        /** 群红包*/
        redpacketVCType = RPRedpacketControllerTypeGroup;
        userInfo.userID = self.conversation.conversationId;//如果是群红包，只要当前群ID即可
        
    }
    
    /** 发红包方法*/
    [RedpacketViewControl presentRedpacketViewController:redpacketVCType
                                         fromeController:self
                                        groupMemberCount:groupArray.count
                                   withRedpacketReceiver:userInfo
                                         andSuccessBlock:^(RPRedpacketModel *model) {
                                             
                                             [weakSelf sendRedPacketMessage:model];
                                             
                                         } withFetchGroupMemberListBlock:^(RedpacketMemberListFetchBlock completionHandle) {
                                             
                                             /** 定向红包群成员列表页面，获取群成员列表 */
                                             NSString *gid;
                                             if ([self.groupDict objectForKey:@"gid"]) {
                                                 gid = [self.groupDict objectForKey:@"gid"];
                                             }else if ([self.groupDict objectForKey:@"family_to_id"]){
                                                 gid = [self.groupDict objectForKey:@"family_to_id"];;
                                             }
                                             [RYApiTool RYGetGroupsDetailWithGroupId:gid
                                                                             success:^(NSDictionary *msg) {
                                                                                 if (msg) {
                                                                                     NSMutableArray *mArray = [[NSMutableArray alloc] init];
                                                                                     NSArray *members = [msg objectForKey:@"member"];
                                                                                     for (NSDictionary *memberDict in members) {
                                                                                        RPUserInfo *userInfo = [RPUserInfo new];
                                                                                        userInfo.userName = [memberDict objectForKey:@"nickname"];
                                                                                        userInfo.avatar = [memberDict objectForKey:@"userIcon"];
                                                                                        userInfo.userID = [memberDict objectForKey:@"imId"];
                                                                                        [mArray addObject:userInfo];
                                                                                     }
                                                                                     completionHandle(mArray);
                                                                                 }
                                                                                 
                                                                             } failure:^(NSString *errormsg) {
                                                                                 
                                                                             }];
                                             
                                             
                                         }];

}

/** 发送红包消息*/
- (void)sendRedPacketMessage:(RPRedpacketModel *)model
{
    NSDictionary *mDic = [RPRedpacketUnionHandle dictWithRedpacketModel:model isACKMessage:NO];
    NSString *messageText = [NSString stringWithFormat:@"[%@]%@", @"红包", model.greeting];
    [self sendTextMessage:messageText withExt:mDic];
}

/** 发送红包被抢的消息*/
- (void)sendRedpacketHasBeenTaked:(RPRedpacketModel *)messageModel
{
    NSString *currentUser = [EMClient sharedClient].currentUsername;
    NSString *senderId = messageModel.sender.userID;
    NSString *conversationId = self.conversation.conversationId;
    
    //  生成红包消息体
    NSDictionary *dic = [RPRedpacketUnionHandle dictWithRedpacketModel:messageModel isACKMessage:YES];
    
    NSString *text = [NSString stringWithFormat:@"你领取了%@发的红包", messageModel.sender.userName];
    
    if (self.conversation.type == EMConversationTypeChat) {
        
        [self sendTextMessage:text withExt:dic];
        
    }else{//群
        
        if ([senderId isEqualToString:currentUser]) {
            
            text = @"你领取了自己的红包";
            
        }else {
            
            /** 如果不是自己发的红包，则发送抢红包消息给对方 */
            [[EMClient sharedClient].chatManager sendMessage:[self createCmdMessageWithModel:messageModel]
                                                    progress:nil
                                                  completion:nil];
            
        }
        
        EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:text];
        
        EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:conversationId
                                                                      from:currentUser
                                                                        to:conversationId
                                                                      body:textMessageBody
                                                                       ext:dic];
        textMessage.chatType = (EMChatType)self.conversation.type;
        textMessage.isRead = YES;
        NSLog(@"-%@",textMessage.ext);
        NSMutableDictionary *dic = textMessage.ext.mutableCopy;
        [dic addEntriesFromDictionary:self.extDict];
        textMessage.ext = dic;
        
        /** 刷新当前聊天界面 */
        [self addMessageToDataSource:textMessage progress:nil];
        
        /** 存入当前会话并存入数据库 */
        [self.conversation insertMessage:textMessage error:nil];
        
    }
}

//  生成环信CMD(透传消息)消息对象
- (EMMessage *)createCmdMessageWithModel:(RPRedpacketModel *)model
{
    NSDictionary *dict = [RPRedpacketUnionHandle dictWithRedpacketModel:model isACKMessage:YES];
    
    NSString *currentUser = [EMClient sharedClient].currentUsername;
    NSString *toUser = model.sender.userID;
    EMCmdMessageBody *cmdChat = [[EMCmdMessageBody alloc] initWithAction:REDPACKET_CMD_MESSAGE];
    
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId
                                                              from:currentUser
                                                                to:toUser
                                                              body:cmdChat
                                                               ext:dict];
    message.chatType = EMChatTypeChat;
    NSLog(@"--%@",message.ext);
    NSMutableDictionary *dic = message.ext.mutableCopy;
    [dic addEntriesFromDictionary:self.extDict];
    message.ext = dic;
    
    return message;
}

/** 抢红包事件*/
- (void)messageCellSelected:(id<IMessageModel>)model
{
    __weak typeof(self) weakSelf = self;
    
    if ([AnalysisRedpacketModel messageCellTypeWithDict:model.message.ext] == MessageCellTypeRedpaket) {
        [self.view endEditing:YES];
        
        NSLog(@"==%@",model.message.ext);
        NSLog(@"==%@",model.message.from);
        RPRedpacketModel *messageModel = [RPRedpacketUnionHandle modelWithChannelRedpacketDic:model.message.ext
                                                                                    andSender:[self profileEntityWith:model.message.from ext:model.message.ext]];
        
        [RedpacketViewControl redpacketTouchedWithMessageModel:messageModel
                                            fromViewController:self
                                            redpacketGrabBlock:^(RPRedpacketModel *messageModel) {
                                                
                                                /** 抢到红包后，发送红包被抢的消息*/
                                                if (messageModel.redpacketType != RPRedpacketTypeAmount) {
                                                    
                                                    [weakSelf sendRedpacketHasBeenTaked:messageModel];
                                                    
                                                }
                                                
                                            } advertisementAction:^(id args) {
                                                
                                                [weakSelf advertisementAction:args];
                                                
                                            }];
        
    } else {
        
        [super messageCellSelected:model];
        
    }

}

- (void)advertisementAction:(id)args
{
#ifdef AliAuthPay
    /** 营销红包事件处理*/
    RPAdvertInfo *adInfo  =args;
    switch (adInfo.AdvertisementActionType) {
        case RedpacketAdvertisementReceive:
            /** 用户点击了领取红包按钮*/
            break;
            
        case RedpacketAdvertisementAction: {
            /** 用户点击了去看看按钮，进入到商户定义的网页 */
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:adInfo.shareURLString]];
            [webView loadRequest:request];
            
            UIViewController *webVc = [[UIViewController alloc] init];
            [webVc.view addSubview:webView];
            [(UINavigationController *)self.presentedViewController pushViewController:webVc animated:YES];
            
        }
            break;
            
        case RedpacketAdvertisementShare: {
            /** 点击了分享按钮，开发者可以根据需求自定义，动作。*/
            [[[UIAlertView alloc]initWithTitle:nil
                                       message:@"点击「分享」按钮，红包SDK将该红包素材内配置的分享链接传递给商户APP，由商户APP自行定义分享渠道完成分享动作。"
                                      delegate:nil
                             cancelButtonTitle:@"我知道了"
                             otherButtonTitles:nil] show];
        }
            break;
            
        default:
            break;
    }
#else
    NSDictionary *dict =args;
    NSInteger actionType = [args[@"actionType"] integerValue];
    switch (actionType) {
        case 0:
            // 点击了领取红包
            break;
        case 1: {
            // 点击了去看看按钮，此处为演示
            UIViewController     *VC = [[UIViewController alloc]init];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
            [VC.view addSubview:webView];
            NSString *url = args[@"LandingPage"];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [webView loadRequest:request];
            [(UINavigationController *)self.presentedViewController pushViewController:VC animated:YES];
        }
            break;
        case 2: {
            // 点击了分享按钮，开发者可以根据需求自定义，动作。
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"点击「分享」按钮，红包SDK将该红包素材内配置的分享链接传递给商户APP，由商户APP自行定义分享渠道完成分享动作。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
#endif
}




@end
