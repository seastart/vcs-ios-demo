//
//  FWNetCallBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/18.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VCSSDK/VCSNetCall.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 呼叫服务邀请入会通知回调
typedef void(^FWNetCallBridgeInviteBlock)(InviteNotification *notify);

/// 呼叫服务邀请入会确认通知回调
typedef void(^FWNetCallBridgeInviteConfirmBlock)(InviteConfirm *notify);

/// 呼叫服务成员的通话状态通知回调
typedef void(^FWNetCallBridgeAccountCallStatusBlock)(WaitingRoomBroadcast *notify);

/// 呼叫服务自己的通话状态通知回调
typedef void(^FWNetCallBridgeMyAccountCallStatusBlock)(WaitingRoomUpdate *notify);

/// 呼叫服务应用内推送通知回调
typedef void(^FWNetCallBridgeInAppPushNotificationBlock)(PushNotification *notify);

/// 呼叫服务会议开始通知
typedef void(^FWNetCallBridgeMeetingBeginNotificationBlock)(MeetingBeginNotify *notify);

@interface FWNetCallBridge : NSObject

/// 初始化方法
+ (FWNetCallBridge *)sharedManager;

/// 连接呼叫服务
/// @param loginModel 登录Model
- (void)startNetCallWithLoginModel:(FWLoginModel *)loginModel;

#pragma mark 发起邀请
/// 发起邀请
/// @param roomNo 房间号码
/// @param targetId 目标账号ID
- (void)inviteWithRoomNo:(NSString *)roomNo targetId:(NSString *)targetId;

#pragma mark 发送邀请入会确认
/// 发送邀请入会请求
/// @param inviteId 邀请人账号ID
/// @param roomNo 房间号码
/// @param targetId 目标账号ID
/// @param isAccepted 是否接受邀请(YES-接受 NO-拒绝)
- (void)inviteConfirmWithInviteId:(NSString *)inviteId roomNo:(NSString *)roomNo targetId:(NSString *)targetId isAccepted:(BOOL)isAccepted;

#pragma mark 发起呼叫
/// 发起呼叫
/// @param accountsArray 呼叫列表
/// @param currentMember 当前成员
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
/// @param role 参会角色
- (void)callWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray currentMember:(WaitingAccount *)currentMember roomNo:(NSString *)roomNo restart:(BOOL)restart role:(ConferenceRole)role;

#pragma mark 取消呼叫
/// 取消呼叫
/// @param accountsArray 取消呼叫列表
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
- (void)callCancelNewWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray roomNo:(NSString *)roomNo;

#pragma mark 从呼叫中移除
/// 从呼叫中移除
/// @param accountsArray 移除目标用户列表(空集合则移除所有人)
/// @param roomNo 房间ID
- (void)callRemoveNewWithAccountsArray:(nullable NSMutableArray<RemoveAccount *> *)accountsArray roomNo:(NSString *)roomNo;

#pragma mark 更新帐户信息
/// 更新帐户信息
/// @param account 账户信息
- (void)updateWaitingAccountInfo:(WaitingAccount *)account;

#pragma mark 停止并释放呼叫服务
/// 停止并释放呼叫服务
- (void)stop;

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
@property (copy, nonatomic) FWNetCallBridgeInviteBlock inviteBlock;

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
/// @param inviteBlock 呼叫服务邀请入会通知回调
- (void)inviteBlock:(FWNetCallBridgeInviteBlock)inviteBlock;

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
@property (copy, nonatomic) FWNetCallBridgeInviteConfirmBlock inviteConfirmBlock;

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
/// @param inviteConfirmBlock 呼叫服务邀请入会确认通知回调
- (void)inviteConfirmBlock:(FWNetCallBridgeInviteConfirmBlock)inviteConfirmBlock;

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
@property (copy, nonatomic) FWNetCallBridgeAccountCallStatusBlock accountCallStatusBlock;

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
/// @param accountCallStatusBlock 呼叫服务成员的通话状态通知回调
- (void)accountCallStatusBlock:(FWNetCallBridgeAccountCallStatusBlock)accountCallStatusBlock;

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
@property (copy, nonatomic) FWNetCallBridgeMyAccountCallStatusBlock myAccountCallStatusBlock;

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
/// @param myAccountCallStatusBlock 呼叫服务自己的通话状态通知回调
- (void)myAccountCallStatusBlock:(FWNetCallBridgeMyAccountCallStatusBlock)myAccountCallStatusBlock;

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
@property (copy, nonatomic) FWNetCallBridgeInAppPushNotificationBlock inAppPushNotificationBlock;

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
/// @param inAppPushNotificationBlock 呼叫服务应用内推送通知回调
- (void)inAppPushNotificationBlock:(FWNetCallBridgeInAppPushNotificationBlock)inAppPushNotificationBlock;

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
@property (copy, nonatomic) FWNetCallBridgeMeetingBeginNotificationBlock meetingBeginNotificationBlock;

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
/// @param meetingBeginNotificationBlock 呼叫服务会议开始通知
- (void)meetingBeginNotificationBlock:(FWNetCallBridgeMeetingBeginNotificationBlock)meetingBeginNotificationBlock;

@end

NS_ASSUME_NONNULL_END
