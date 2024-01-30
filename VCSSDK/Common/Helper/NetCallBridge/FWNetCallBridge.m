//
//  FWNetCallBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/18.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWNetCallBridge.h"

@interface FWNetCallBridge ()<VCSNetCallManagerProtocol>

@end

@implementation FWNetCallBridge

/// 初始化方法
+ (FWNetCallBridge *)sharedManager {
    
    static FWNetCallBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FWNetCallBridge alloc] init];
    });
    return manager;
}

/// 连接呼叫服务
/// @param accountId 帐号ID
/// @param token 登录token
/// @param meetingHost 连接地址
/// @param meetingPort 连接端口
- (void)startNetCallWithLoginModel:(FWLoginModel *)loginModel {
    
    /// 呼叫服务版本信息
    SGLOG(@"++++++++++++%@", [[VCSNetCallManager sharedManager] getVersionInfo]);
    /// 设置代理
    [VCSNetCallManager sharedManager].delegate = self;
    /// 连接呼叫服务
    [[VCSNetCallManager sharedManager] startNetCallWithAccountId:loginModel.data.account.id token:loginModel.data.token meetingHost:loginModel.data.reg.addr meetingPort:loginModel.data.reg.port];
}

#pragma mark 发起邀请
/// 发起邀请
/// @param roomNo 房间号码
/// @param targetId 目标账号ID
- (void)inviteWithRoomNo:(NSString *)roomNo targetId:(NSString *)targetId {
    
    [[VCSNetCallManager sharedManager] inviteWithRoomNo:roomNo targetId:targetId];
}

#pragma mark 发送邀请入会确认
/// 发送邀请入会请求
/// @param inviteId 邀请人账号ID
/// @param roomNo 房间号码
/// @param targetId 目标账号ID
/// @param isAccepted 是否接受邀请(YES-接受 NO-拒绝)
- (void)inviteConfirmWithInviteId:(NSString *)inviteId roomNo:(NSString *)roomNo targetId:(NSString *)targetId isAccepted:(BOOL)isAccepted {
    
    [[VCSNetCallManager sharedManager] inviteConfirmWithInviteId:inviteId roomNo:roomNo targetId:targetId isAccepted:isAccepted];
}

#pragma mark 发起呼叫
/// 发起呼叫
/// @param accountsArray 呼叫列表
/// @param currentMember 当前成员
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
- (void)callWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray currentMember:(WaitingAccount *)currentMember roomNo:(NSString *)roomNo restart:(BOOL)restart {
    
    [[VCSNetCallManager sharedManager] callWithAccountsArray:accountsArray currentMember:currentMember roomNo:roomNo restart:restart];
}

#pragma mark 发起呼叫
/// 发起呼叫
/// @param accountsArray 呼叫列表
/// @param currentMember 当前成员
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
/// @param role 参会角色
- (void)callWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray currentMember:(WaitingAccount *)currentMember roomNo:(NSString *)roomNo restart:(BOOL)restart role:(ConferenceRole)role {
    
    [[VCSNetCallManager sharedManager] callWithAccountsArray:accountsArray currentMember:currentMember roomNo:roomNo restart:restart role:role];
}

#pragma mark 取消呼叫
/// 取消呼叫
/// @param accountsArray 取消呼叫列表
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
- (void)callCancelNewWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray roomNo:(NSString *)roomNo {
    
    [[VCSNetCallManager sharedManager] callCancelNewWithAccountsArray:accountsArray roomNo:roomNo];
}

#pragma mark 从呼叫中移除
/// 从呼叫中移除
/// @param accountsArray 移除目标用户列表(空集合则移除所有人)
/// @param roomNo 房间ID
- (void)callRemoveNewWithAccountsArray:(nullable NSMutableArray<RemoveAccount *> *)accountsArray roomNo:(NSString *)roomNo {
    
    [[VCSNetCallManager sharedManager] callRemoveNewWithAccountsArray:accountsArray roomNo:roomNo];
}

#pragma mark 更新帐户信息
/// 更新帐户信息
/// @param account 账户信息
- (void)updateWaitingAccountInfo:(WaitingAccount *)account {
    
    [[VCSNetCallManager sharedManager] updateWaitingAccountInfo:account];
}

/// 停止并释放呼叫服务
- (void)stop {
    
    /// 停止并释放呼叫服务
    [[VCSNetCallManager sharedManager] stop];
}

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
/// @param inviteBlock 呼叫服务邀请入会通知回调
- (void)inviteBlock:(FWNetCallBridgeInviteBlock)inviteBlock {
    
    self.inviteBlock = inviteBlock;
}

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
/// @param inviteConfirmBlock 呼叫服务邀请入会确认通知回调
- (void)inviteConfirmBlock:(FWNetCallBridgeInviteConfirmBlock)inviteConfirmBlock {
    
    self.inviteConfirmBlock = inviteConfirmBlock;
}

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
/// @param accountCallStatusBlock 呼叫服务成员的通话状态通知回调
- (void)accountCallStatusBlock:(FWNetCallBridgeAccountCallStatusBlock)accountCallStatusBlock {
    
    self.accountCallStatusBlock = accountCallStatusBlock;
}

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
/// @param myAccountCallStatusBlock 呼叫服务自己的通话状态通知回调
- (void)myAccountCallStatusBlock:(FWNetCallBridgeMyAccountCallStatusBlock)myAccountCallStatusBlock {
    
    self.myAccountCallStatusBlock = myAccountCallStatusBlock;
}

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
/// @param inAppPushNotificationBlock 呼叫服务应用内推送通知回调
- (void)inAppPushNotificationBlock:(FWNetCallBridgeInAppPushNotificationBlock)inAppPushNotificationBlock {
    
    self.inAppPushNotificationBlock = inAppPushNotificationBlock;
}

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
/// @param meetingBeginNotificationBlock 呼叫服务会议开始通知
- (void)meetingBeginNotificationBlock:(FWNetCallBridgeMeetingBeginNotificationBlock)meetingBeginNotificationBlock {
    
    self.meetingBeginNotificationBlock = meetingBeginNotificationBlock;
}

#pragma mark - ------- VCSNetCallManagerProtocol的代理方法 -------
#pragma mark 呼叫服务响应回调
/// 呼叫服务响应回调
/// @param command cmd指令
/// @param result 结果
- (void)onListenNetCallResultCommand:(Command)command result:(Result)result {
    
    switch (command) {
        case Command_CmdRegHeartbeat: {
            if (result == Result_ResultOk) {
                SGLOG(@"++++++++++++呼叫服务心跳发送成功");
            } else {
                SGLOG(@"++++++++++++呼叫服务心跳发送失败");
            }
        }
            break;
        case Command_CmdRegChatRsp: {
            if (result == Result_ResultOk) {
                SGLOG(@"++++++++++++呼叫服务聊天消息发送成功");
            } else {
                SGLOG(@"++++++++++++呼叫服务聊天消息发送失败");
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

#pragma mark 成员的通话状态通知
/// 成员的通话状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallAccountCallStatusWithNotify:(WaitingRoomBroadcast *)notify error:(NSError *)error {
    
    /// 呼叫服务成员的通话状态通知回调
    if (self.accountCallStatusBlock) {
        self.accountCallStatusBlock(notify);
    }
}

#pragma mark 自己的通话状态通知
/// 自己的通话状态通知
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
        SGLOG(@"++++++++++++呼叫服务聊天消息发送成功，消息ID为 = %@", notify.id_p);
    } else {
        SGLOG(@"++++++++++++呼叫服务聊天消息发送失败，消息ID为 = %@", notify.id_p);
    }
}

#pragma mark 事件命令透传通知
/// 事件命令透传通知
/// @param command 消息指令
/// @param content 消息内容
- (void)onListenNetCallEventWithCommand:(VCSCommandEventState)command content:(NSString *)content {
    
    SGLOG(@"事件命令透传通知-UDP呼叫服务 Command = %ld content = %@", command, content);
}

@end
