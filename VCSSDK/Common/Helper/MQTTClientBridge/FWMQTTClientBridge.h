//
//  FWMQTTClientBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/16.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VCSSDK/VCSNetCall.h>
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 呼叫服务邀请入会通知回调
typedef void(^FWMQTTClientBridgeInviteBlock)(InviteNotification *notify);

/// 呼叫服务邀请入会确认通知回调
typedef void(^FWMQTTClientBridgeInviteConfirmBlock)(InviteConfirm *notify);

/// 呼叫服务成员的通话状态通知回调
typedef void(^FWMQTTClientBridgeAccountCallStatusBlock)(WaitingRoomBroadcast *notify);

/// 呼叫服务自己的通话状态通知回调
typedef void(^FWMQTTClientBridgeMyAccountCallStatusBlock)(WaitingRoomUpdate *notify);

/// 呼叫服务应用内推送通知回调
typedef void(^FWMQTTClientBridgeInAppPushNotificationBlock)(PushNotification *notify);

/// 呼叫服务聊天消息通知回调
typedef void(^FWMQTTClientBridgeChatNotificationBlock)(RegChatNotify *notify);

/// 呼叫服务会议开始通知
typedef void(^FWMQTTClientBridgeMeetingBeginNotificationBlock)(MeetingBeginNotify *notify);

@interface FWMQTTClientBridge : NSObject

/// 初始化方法
+ (FWMQTTClientBridge *)sharedManager;

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
/// @param initiatorId 邀请发起者ID
/// @param roomNo 房间号码
/// @param response 邀请响应
- (void)inviteConfirmWithInitiatorId:(NSString *)initiatorId roomNo:(NSString *)roomNo response:(InviteResponse)response;

#pragma mark 发起呼叫
/// 发起呼叫
/// @param accountsArray 呼叫列表
/// @param currentMember 当前成员
/// @param roomNo 房间ID
/// @param restart 是否重新开始(YES-忽略上次的呼叫 NO-叠加上次的呼叫)
- (void)callWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray currentMember:(WaitingAccount *)currentMember roomNo:(NSString *)roomNo restart:(BOOL)restart;

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

#pragma mark 发送应用内推送
/// 发送应用内推送
/// @param receiversArray 接收者用户ID集合
/// @param message 推送消息内容
- (void)inAppPushWithReceiversArray:(NSMutableArray<NSString *> *)receiversArray message:(NSData *)message;

#pragma mark 发送单聊文本消息
/// 发送单聊文本消息
/// @param message 文本消息
/// @param receiverID 接收者ID
- (void)sendTextWithMessage:(NSString *)message receiverID:(NSString *)receiverID;

#pragma mark 发送群聊文本消息
/// 发送群聊文本消息
/// @param message 文本消息
/// @param groupID 群组ID
- (void)sendTextGroupWithMessage:(NSString *)message groupID:(NSString *)groupID;

#pragma mark 发送单聊图片消息
/// 发送群聊图片消息
/// @param imagePath 图片地址
/// @param receiverID 接收者ID
- (void)sendImageWithImagePath:(NSString *)imagePath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊图片消息
/// 发送单聊图片消息
/// @param imagePath 图片地址
/// @param groupID 群组ID
- (void)sendImageGroupWithImagePath:(NSString *)imagePath groupID:(NSString *)groupID;

#pragma mark 发送单聊语音消息
/// 发送单聊语音消息
/// @param imagePath 图片地址
/// @param receiverID 接收者ID
- (void)sendAudioWithAudioPath:(NSString *)audioPath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊语音消息
/// 发送单聊语音消息
/// @param imagePath 图片地址
/// @param groupID 群组ID
- (void)sendAudioGroupWithAudioPath:(NSString *)audioPath groupID:(NSString *)groupID;

#pragma mark 发送单聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param receiverID 接收者ID
- (void)sendVideoWithVideoPath:(NSString *)videoPath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param groupID 群组ID
- (void)sendVideoGroupWithVideoPath:(NSString *)videoPath groupID:(NSString *)groupID;

#pragma mark 发送单聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param receiverID 接收者ID
- (void)sendFileWithFilePath:(NSString *)filePath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param groupID 群组ID
- (void)sendFileGroupWithFilePath:(NSString *)filePath groupID:(NSString *)groupID;

#pragma mark 停止并释放呼叫服务
/// 停止并释放呼叫服务
- (void)stop;

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
@property (copy, nonatomic) FWMQTTClientBridgeInviteBlock inviteBlock;

#pragma mark 呼叫服务邀请入会通知回调
/// 呼叫服务邀请入会通知回调
/// @param inviteBlock 呼叫服务邀请入会通知回调
- (void)inviteBlock:(FWMQTTClientBridgeInviteBlock)inviteBlock;

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
@property (copy, nonatomic) FWMQTTClientBridgeInviteConfirmBlock inviteConfirmBlock;

#pragma mark 呼叫服务邀请入会确认通知回调
/// 呼叫服务邀请入会确认通知回调
/// @param inviteConfirmBlock 呼叫服务邀请入会确认通知回调
- (void)inviteConfirmBlock:(FWMQTTClientBridgeInviteConfirmBlock)inviteConfirmBlock;

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
@property (copy, nonatomic) FWMQTTClientBridgeAccountCallStatusBlock accountCallStatusBlock;

#pragma mark 呼叫服务成员的通话状态通知回调
/// 呼叫服务成员的通话状态通知回调
/// @param accountCallStatusBlock 呼叫服务成员的通话状态通知回调
- (void)accountCallStatusBlock:(FWMQTTClientBridgeAccountCallStatusBlock)accountCallStatusBlock;

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
@property (copy, nonatomic) FWMQTTClientBridgeMyAccountCallStatusBlock myAccountCallStatusBlock;

#pragma mark 呼叫服务自己的通话状态通知回调
/// 呼叫服务自己的通话状态通知回调
/// @param myAccountCallStatusBlock 呼叫服务自己的通话状态通知回调
- (void)myAccountCallStatusBlock:(FWMQTTClientBridgeMyAccountCallStatusBlock)myAccountCallStatusBlock;

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
@property (copy, nonatomic) FWMQTTClientBridgeInAppPushNotificationBlock inAppPushNotificationBlock;

#pragma mark 呼叫服务应用内推送通知回调
/// 呼叫服务应用内推送通知回调
/// @param inAppPushNotificationBlock 呼叫服务应用内推送通知回调
- (void)inAppPushNotificationBlock:(FWMQTTClientBridgeInAppPushNotificationBlock)inAppPushNotificationBlock;

#pragma mark 呼叫服务聊天消息通知回调
/// 呼叫服务聊天消息通知回调
@property (copy, nonatomic) FWMQTTClientBridgeChatNotificationBlock chatNotificationBlock;

#pragma mark 呼叫服务聊天消息通知回调
/// 呼叫服务聊天消息通知回调
/// @param chatNotificationBlock 呼叫服务聊天消息通知回调
- (void)chatNotificationBlock:(FWMQTTClientBridgeChatNotificationBlock)chatNotificationBlock;

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
@property (copy, nonatomic) FWMQTTClientBridgeMeetingBeginNotificationBlock meetingBeginNotificationBlock;

#pragma mark 呼叫服务会议开始通知
/// 呼叫服务会议开始通知
/// @param meetingBeginNotificationBlock 呼叫服务会议开始通知
- (void)meetingBeginNotificationBlock:(FWMQTTClientBridgeMeetingBeginNotificationBlock)meetingBeginNotificationBlock;

@end

NS_ASSUME_NONNULL_END
