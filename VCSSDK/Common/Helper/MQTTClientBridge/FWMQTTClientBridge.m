//
//  FWMQTTClientBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/16.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWMQTTClientBridge.h"

@interface FWMQTTClientBridge ()<VCSMQTTClientManagerProtocol>

@end

@implementation FWMQTTClientBridge

#pragma mark 单例获取管理类
/// 单例获取管理类
+ (FWMQTTClientBridge *)sharedManager {
    
    static FWMQTTClientBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FWMQTTClientBridge alloc] init];
    });
    return manager;
}

#pragma mark 连接呼叫服务
/// 连接呼叫服务
/// @param accountId 帐号ID
/// @param token 登录token
/// @param meetingHost 连接地址
/// @param meetingPort 连接端口
- (void)startNetCallWithLoginModel:(FWLoginModel *)loginModel {
    
    /// 呼叫服务版本信息
    SGLOG(@"++++++++++++%@", [[VCSMQTTClientManager sharedManager] getVersionInfo]);
    /// 连接呼叫服务
    [[VCSMQTTClientManager sharedManager] startNetCallWithAccountId:loginModel.data.account.id name:loginModel.data.account.name nickname:loginModel.data.account.nickname portrait:loginModel.data.account.portrait delegate:self];
}

#pragma mark 发起邀请
/// 发起邀请
/// @param roomNo 房间号码
/// @param targetId 目标账号ID
- (void)inviteWithRoomNo:(NSString *)roomNo targetId:(NSString *)targetId {
    
    [[VCSMQTTClientManager sharedManager] inviteWithRoomNo:roomNo targetId:targetId];
}

#pragma mark 发送邀请入会确认
/// 发送邀请入会请求
/// @param initiatorId 邀请发起者ID
/// @param roomNo 房间号码
/// @param response 邀请响应
- (void)inviteConfirmWithInitiatorId:(NSString *)initiatorId roomNo:(NSString *)roomNo response:(InviteResponse)response {
    
    [[VCSMQTTClientManager sharedManager] inviteConfirmWithInitiatorId:initiatorId roomNo:roomNo response:response];
}

#pragma mark 发起呼叫
/// 发起呼叫
/// @param accountsArray 呼叫列表
/// @param currentMember 当前成员
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
/// @param role 参会角色
- (void)callWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray currentMember:(WaitingAccount *)currentMember roomNo:(NSString *)roomNo restart:(BOOL)restart role:(ConferenceRole)role {
    
    [[VCSMQTTClientManager sharedManager] callWithAccountsArray:accountsArray currentMember:currentMember roomNo:roomNo restart:restart role:role];
}

#pragma mark 取消呼叫
/// 取消呼叫
/// @param accountsArray 取消呼叫列表
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
- (void)callCancelNewWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray roomNo:(NSString *)roomNo {
    
    [[VCSMQTTClientManager sharedManager] callCancelNewWithAccountsArray:accountsArray roomNo:roomNo];
}

#pragma mark 从呼叫中移除
/// 从呼叫中移除
/// @param accountsArray 移除目标用户列表(空集合则移除所有人)
/// @param roomNo 房间ID
- (void)callRemoveNewWithAccountsArray:(nullable NSMutableArray<RemoveAccount *> *)accountsArray roomNo:(NSString *)roomNo {
    
    [[VCSMQTTClientManager sharedManager] callRemoveNewWithAccountsArray:accountsArray roomNo:roomNo];
}

#pragma mark 更新帐户信息
/// 更新帐户信息
/// @param account 账户信息
- (void)updateWaitingAccountInfo:(WaitingAccount *)account {
    
    [[VCSMQTTClientManager sharedManager] updateWaitingAccountInfo:account];
}

#pragma mark 发送应用内推送
/// 发送应用内推送
/// @param receiversArray 接收者用户ID集合
/// @param message 推送消息内容
- (void)inAppPushWithReceiversArray:(NSMutableArray<NSString *> *)receiversArray message:(NSData *)message {
    
    [[VCSMQTTClientManager sharedManager] inAppPushWithReceiversArray:receiversArray message:message];
}

#pragma mark 发送单聊文本消息
/// 发送单聊文本消息
/// @param message 文本消息
/// @param receiverID 接收者ID
- (void)sendTextWithMessage:(NSString *)message receiverID:(NSString *)receiverID {
    
    ImBody *imBody = [[VCSMQTTClientManager sharedManager] sendTextWithMessage:message receiverID:receiverID];
    SGLOG(@"++++++++++++发送单聊文本消息回执 = %@", imBody);
}

#pragma mark 发送群聊文本消息
/// 发送群聊文本消息
/// @param message 文本消息
/// @param groupID 群组ID
- (void)sendTextGroupWithMessage:(NSString *)message groupID:(NSString *)groupID {
    
    [[VCSMQTTClientManager sharedManager] sendTextGroupWithMessage:message groupID:groupID];
}

#pragma mark 发送单聊图片消息
/// 发送群聊图片消息
/// @param imagePath 图片地址
/// @param receiverID 接收者ID
- (void)sendImageWithImagePath:(NSString *)imagePath receiverID:(NSString *)receiverID {
    
    [[VCSMQTTClientManager sharedManager] sendImageWithImagePath:imagePath receiverID:receiverID];
}

#pragma mark 发送群聊图片消息
/// 发送单聊图片消息
/// @param imagePath 图片地址
/// @param groupID 群组ID
- (void)sendImageGroupWithImagePath:(NSString *)imagePath groupID:(NSString *)groupID {
    
    [[VCSMQTTClientManager sharedManager] sendImageGroupWithImagePath:imagePath groupID:groupID];
}

#pragma mark 发送单聊语音消息
/// 发送单聊语音消息
/// @param imagePath 图片地址
/// @param receiverID 接收者ID
- (void)sendAudioWithAudioPath:(NSString *)audioPath receiverID:(NSString *)receiverID {
    
    [[VCSMQTTClientManager sharedManager] sendAudioWithAudioPath:audioPath receiverID:receiverID];
}

#pragma mark 发送群聊语音消息
/// 发送单聊语音消息
/// @param imagePath 图片地址
/// @param groupID 群组ID
- (void)sendAudioGroupWithAudioPath:(NSString *)audioPath groupID:(NSString *)groupID {
    
    [[VCSMQTTClientManager sharedManager] sendAudioGroupWithAudioPath:audioPath groupID:groupID];
}

#pragma mark 发送单聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param receiverID 接收者ID
- (void)sendVideoWithVideoPath:(NSString *)videoPath receiverID:(NSString *)receiverID {
    
    [[VCSMQTTClientManager sharedManager] sendVideoWithVideoPath:videoPath receiverID:receiverID];
}

#pragma mark 发送群聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param groupID 群组ID
- (void)sendVideoGroupWithVideoPath:(NSString *)videoPath groupID:(NSString *)groupID {
    
    [[VCSMQTTClientManager sharedManager] sendVideoGroupWithVideoPath:videoPath groupID:groupID];
}

#pragma mark 发送单聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param receiverID 接收者ID
- (void)sendFileWithFilePath:(NSString *)filePath receiverID:(NSString *)receiverID {
    
    [[VCSMQTTClientManager sharedManager] sendFileWithFilePath:filePath receiverID:receiverID];
}

#pragma mark 发送群聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param groupID 群组ID
- (void)sendFileGroupWithFilePath:(NSString *)filePath groupID:(NSString *)groupID {
    
    [[VCSMQTTClientManager sharedManager] sendFileGroupWithFilePath:filePath groupID:groupID];
}

#pragma mark 停止并释放呼叫服务
/// 停止并释放呼叫服务
- (void)stop {
    
    /// 销毁释放MQTT呼叫服务资源
    [[VCSMQTTClientManager sharedManager] destroy];
}

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
/// @param inviteBlock 呼叫服务邀请入会通知回调
- (void)inviteBlock:(FWMQTTClientBridgeInviteBlock)inviteBlock {
    
    self.inviteBlock = inviteBlock;
}

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
/// @param inviteConfirmBlock 呼叫服务邀请入会确认通知回调
- (void)inviteConfirmBlock:(FWMQTTClientBridgeInviteConfirmBlock)inviteConfirmBlock {
    
    self.inviteConfirmBlock = inviteConfirmBlock;
}

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
/// @param accountCallStatusBlock 呼叫服务成员的通话状态通知回调
- (void)accountCallStatusBlock:(FWMQTTClientBridgeAccountCallStatusBlock)accountCallStatusBlock {
    
    self.accountCallStatusBlock = accountCallStatusBlock;
}

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
/// @param myAccountCallStatusBlock 呼叫服务自己的通话状态通知回调
- (void)myAccountCallStatusBlock:(FWMQTTClientBridgeMyAccountCallStatusBlock)myAccountCallStatusBlock {
    
    self.myAccountCallStatusBlock = myAccountCallStatusBlock;
}

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
/// @param inAppPushNotificationBlock 呼叫服务应用内推送通知回调
- (void)inAppPushNotificationBlock:(FWMQTTClientBridgeInAppPushNotificationBlock)inAppPushNotificationBlock {
    
    self.inAppPushNotificationBlock = inAppPushNotificationBlock;
}

#pragma mark 呼叫服务聊天消息通知回调
/// 呼叫服务聊天消息通知回调
/// @param chatNotificationBlock 呼叫服务聊天消息通知回调
- (void)chatNotificationBlock:(FWMQTTClientBridgeChatNotificationBlock)chatNotificationBlock {
    
    self.chatNotificationBlock = chatNotificationBlock;
}

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
/// @param meetingBeginNotificationBlock 呼叫服务会议开始通知
- (void)meetingBeginNotificationBlock:(FWMQTTClientBridgeMeetingBeginNotificationBlock)meetingBeginNotificationBlock {
    
    self.meetingBeginNotificationBlock = meetingBeginNotificationBlock;
}

#pragma mark - ------- VCSMQTTClientManagerProtocol的代理方法 -------
#pragma mark 呼叫服务响应回调
/// 呼叫服务响应回调
/// @param command cmd指令
/// @param result 结果
- (void)onListenNetCallResultCommand:(Command)command result:(Result)result {
    
    switch (command) {
        case Command_CmdRegHeartbeat: {
            if (result == Result_ResultOk) {
                SGLOG(@"++++++++++++MQTT呼叫服务心跳发送成功");
            } else {
                SGLOG(@"++++++++++++MQTT呼叫服务心跳发送失败");
            }
        }
            break;
        case Command_CmdRegChatRsp: {
            if (result == Result_ResultOk) {
                SGLOG(@"++++++++++++MQTT呼叫服务聊天消息发送成功");
            } else {
                SGLOG(@"++++++++++++MQTT呼叫服务聊天消息发送失败");
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 邀请入会通知
/// 邀请入会通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInviteWithNotify:(InviteNotification *)notify error:(NSError *)error {
    
    /// 呼叫服务邀请入会通知回调
    if (self.inviteBlock) {
        self.inviteBlock(notify);
    }
}

#pragma mark 邀请入会确认通知
/// 邀请入会确认通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInviteConfirmWithNotify:(InviteConfirm *)notify error:(NSError *)error {
    
    /// 呼叫服务邀请入会确认通知回调
    if (self.inviteConfirmBlock) {
        self.inviteConfirmBlock(notify);
    }
}

#pragma mark 成员的通话状态通知(会议等候室广播)
/// 成员的通话状态通知(会议等候室广播)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallAccountCallStatusWithNotify:(WaitingRoomBroadcast *)notify error:(NSError *)error {
    
    /// 呼叫服务成员的通话状态通知回调
    if (self.accountCallStatusBlock) {
        self.accountCallStatusBlock(notify);
    }
}

#pragma mark 自己的通话状态通知(服务端更新等候者状态)
/// 自己的通话状态通知(服务端更新等候者状态)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMyAccountCallStatusWithNotify:(WaitingRoomUpdate *)notify error:(NSError *)error {
    
    /// 呼叫服务自己的通话状态通知回调
    if (self.myAccountCallStatusBlock) {
        self.myAccountCallStatusBlock(notify);
    }
}

#pragma mark 应用内推送通知
/// 应用内推送通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInAppPushNotificationWithNotify:(PushNotification *)notify error:(NSError *)error {
    
    /// 呼叫服务应用内推送通知回调
    if (self.inAppPushNotificationBlock) {
        self.inAppPushNotificationBlock(notify);
    }
}

#pragma mark 聊天消息通知
/// 聊天消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallChatNotificationWithNotify:(RegChatNotify *)notify error:(NSError *)error {
    
    /// 呼叫服务聊天消息通知回调
    if (self.chatNotificationBlock) {
        self.chatNotificationBlock(notify);
    }
}

#pragma mark 会议开始通知(在线的受邀人员会收到该通知)
/// 会议开始通知(在线的受邀人员会收到该通知)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMeetingBeginNotificationWithNotify:(MeetingBeginNotify *)notify error:(NSError *)error {
    
    /// 呼叫服务会议开始通知
    if (self.meetingBeginNotificationBlock) {
        self.meetingBeginNotificationBlock(notify);
    }
}

#pragma mark 聊天消息发送回执通知
/// 聊天消息发送回执通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallChatResponseWithNotify:(RegChatResponse *)notify error:(NSError *)error {
    
    if (notify.result == ChatResult_ChatOk) {
        SGLOG(@"++++++++++++MQTT呼叫服务聊天消息发送成功，消息ID为 = %@", notify.id_p);
    } else {
        SGLOG(@"++++++++++++MQTT呼叫服务聊天消息发送失败，消息ID为 = %@", notify.id_p);
    }
}

#pragma mark 事件命令透传通知
/// 事件命令透传通知
/// @param command 消息指令
/// @param content 消息内容
- (void)onListenNetCallEventWithCommand:(VCSCommandEventState)command content:(NSString *)content {
    
    SGLOG(@"事件命令透传通知-MQTT呼叫服务 Command = %ld content = %@", command, content);
}

@end
