//
//  VCSMQTTClientManagerProtocol.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/12.
//

#pragma mark - 呼叫服务相关代理
@protocol VCSMQTTClientManagerProtocol <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark 连接状态变化回调
/// 连接状态变化回调
/// @param enable YES-可用 NO-不可用
- (void)onListenNetCallConnectChangeWithEnable:(BOOL)enable;

#pragma mark 呼叫服务响应回调
/// 呼叫服务响应回调
/// @param command cmd指令
/// @param result 结果
- (void)onListenNetCallResultCommand:(Command)command result:(Result)result;

#pragma mark 邀请入会通知
/// 邀请入会通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInviteWithNotify:(InviteNotification *)notify error:(NSError *)error;

#pragma mark 邀请入会确认通知
/// 邀请入会确认通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInviteConfirmWithNotify:(InviteConfirm *)notify error:(NSError *)error;

#pragma mark 成员的通话状态通知(会议等候室广播)
/// 成员的通话状态通知(会议等候室广播)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallAccountCallStatusWithNotify:(WaitingRoomBroadcast *)notify error:(NSError *)error;

#pragma mark 自己的通话状态通知(服务端更新等候者状态)
/// 自己的通话状态通知(服务端更新等候者状态)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMyAccountCallStatusWithNotify:(WaitingRoomUpdate *)notify error:(NSError *)error;

#pragma mark 应用内推送通知
/// 应用内推送通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallInAppPushNotificationWithNotify:(PushNotification *)notify error:(NSError *)error;

#pragma mark 聊天消息通知
/// 聊天消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallChatNotificationWithNotify:(RegChatNotify *)notify error:(NSError *)error;

#pragma mark 会议开始通知(在线的受邀人员会收到该通知)
/// 会议开始通知(在线的受邀人员会收到该通知)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMeetingBeginNotificationWithNotify:(MeetingBeginNotify *)notify error:(NSError *)error;

#pragma mark 会议结束通知(在线的受邀人员会收到该通知)
/// 会议结束通知(在线的受邀人员会收到该通知)
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMeetingEndedNotificationWithNotify:(MeetingEndNotify *)notify error:(NSError *)error;

#pragma mark 会议邀请通知
/// 会议邀请通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallMeetingInviteNotificationWithNotify:(InviteConfNoticeNotify *)notify error:(NSError *)error;

#pragma mark 聊天消息发送回执通知
/// 聊天消息发送回执通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallChatResponseWithNotify:(RegChatResponse *)notify error:(NSError *)error;

#pragma mark 聊天消息撤回通知
/// 聊天消息撤回通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallChatRevokeWithNotify:(RegChatRevokeNotify *)notify error:(NSError *)error;

#pragma mark 预约会议通知
/// 预约会议通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenNetCallRoomPrepareWithNotify:(RoomPrepareNotify *)notify error:(NSError *)error;

#pragma mark 事件命令透传通知
/// 事件命令透传通知
/// @param command 消息指令
/// @param content 消息内容
- (void)onListenNetCallEventWithCommand:(VCSCommandEventState)command content:(NSString *)content;

@end
