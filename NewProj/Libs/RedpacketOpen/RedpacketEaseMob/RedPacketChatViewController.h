//
//  ChatWithRedPacketViewController.h
//  ChatDemo-UI3.0
//
//  Created by Mr.Yang on 16/2/23.
//


#import "ChatViewController.h"

typedef enum
{
    RYPublicGroup = 0,
    RYGroup
}RYGroupType;

/** 带红包功能的聊天窗口 */
@interface RedPacketChatViewController : ChatViewController

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) RYGroupType groupType;

@end
