//
//  VCSChatRoomPackage.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/12.
//

#import <Foundation/Foundation.h>
#import "Models.pbobjc.h"
#import "RoomServer.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 互动服务消息解析结果回调
/// 互动服务消息解析结果回调
/// @param type 报文类型
/// @param command 通知类型
/// @param result 结果
/// @param data 解析出的数据
typedef void(^VCSChatRoomPackageBlock)(PacketType type, Command command, Result result, NSData *data);

@interface VCSChatRoomPackage : NSObject

#pragma mark - 组装互动消息发送报文 报文头(12B) + 报文体(*B)
#pragma mark 进入房间
/// 进入房间
/// @param session 入会凭证 (互动凭证)
/// @param room 会议室
/// @param account 参会人
+ (NSData *)enterRoomWithSession:(NSString *)session room:(Room *)room account:(Account *)account;

#pragma mark 退出房间
/// 退出房间
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
+ (NSData *)exitRoomWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId;

#pragma mark 发送心跳
/// 发送心跳
/// @param session 入会凭证 (互动凭证)
/// @param roomId 房间ID
/// @param account 参会人
+ (NSData *)sendHeartBeatWithSession:(NSString *)session room:(NSString *)roomId account:(Account *)account;

#pragma mark 主持人设置音频设备状态(禁用或开启)
/// 主持人设置音视频设备状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param targetId 目标帐号ID(为空时代表全局禁用)
/// @param audioState 音频设备状态
+ (NSData *)setRoomDeviceStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(NSString *)targetId audioState:(DeviceState)audioState;

#pragma mark 主持人设置视频设备状态(禁用或开启)
/// 主持人设置音视频设备状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param targetId 目标帐号ID(为空时代表全局禁用)
/// @param videoState 视频设备状态
+ (NSData *)setRoomDeviceStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(NSString *)targetId videoState:(DeviceState)videoState;

#pragma mark 主持人设置成员音频状态(禁用或开启)
/// 主持人设置成员音频状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param audioState 音频状态
+ (NSData *)setMemberAudioStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray audioState:(DeviceState)audioState;

#pragma mark 主持人设置成员视频状态(禁用或开启)
/// 主持人设置成员视频状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param videoState 视频状态
+ (NSData *)setMemberVideoStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray videoState:(DeviceState)videoState;

#pragma mark 主持人设置房间音频状态(禁用或开启)
/// 主持人设置房间音频状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param audioState 音频状态
+ (NSData *)setRoomAudioStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId audioState:(DeviceState)audioState;

#pragma mark 主持人设置房间视频状态(禁用或开启)
/// 主持人设置房间视频状态(禁用或开启)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param videoState 视频状态
+ (NSData *)setRoomAudioStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId videoState:(DeviceState)videoState;

#pragma mark 主持人踢人
/// 主持人踢人
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param targetId 目标帐号ID
+ (NSData *)setRoomKickoutWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(NSString *)targetId;

#pragma mark 主持人设置白板状态(打开或关闭)[废弃]
/// 主持人设置白板状态(打开或关闭)[废弃]
/// @param session 入会凭证 (互动凭证)
/// @param accountId 主持人ID
/// @param roomId 房间ID
/// @param openState 是否打开状态(YES-打开，NO-关闭)
+ (NSData *)setRoomWhiteBoardStateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId openState:(BOOL)openState;

#pragma mark 推送码流发生变化
/// 推送码流发生变化
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息
+ (NSData *)changedRoomStreamWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId operation:(Operation)operation stream:(Stream *)stream;

#pragma mark 发送透传消息(自定义消息)
/// 发送透传消息(自定义消息)
/// @param accountId 用户ID
/// @param targetId 目标用户
/// @param roomId 房间ID
/// @param message 自定义消息
+ (NSData *)sendRoomPassthroughWithAccountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId message:(NSString *)message;

#pragma mark 主持人变更码流
/// 主持人变更码流
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param targetId 目标用户
/// @param roomId 房间ID
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息
+ (NSData *)hostChangedRoomStreamWithSession:(NSString *)session accountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId operation:(Operation)operation stream:(Stream *)stream;

#pragma mark 主持人处理举手操作
/// 主持人处理举手操作
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param targetId 目标用户
/// @param roomId 房间ID
/// @param hus 举手类型(HandUpStatus_HusNone-无，HandUpStatus_HusLiftTheBan-解除禁言请求)
/// @param result 处理结果(0-同意，其他-不同意)
+ (NSData *)hostDisposeRoomRaiseHandWithSession:(NSString *)session accountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId hus:(HandUpStatus)hus result:(int32_t)result;

#pragma mark 发送聊天消息
/// 发送聊天消息
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param targetId 目标用户
/// @param roomId 房间ID
/// @param nickname 用户昵称
/// @param portrait 用户头像
/// @param type 消息类型
/// @param message 信息
+ (NSData *)sendRoomChatMessageWithSession:(NSString *)session accountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId nickname:(NSString *)nickname portrait:(NSString *)portrait type:(MessageType)type message:(NSString *)message;

#pragma mark 开始分享(包括：白板、图片、桌面)
/// 开始分享(包括：白板、图片、桌面)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param sharingType 分享类型
/// @param sharingPicURL 分享图片时的图片地址
/// @param sharingRelativePicURL 分享图片时的图片相对地址
/// @param sharingStreamId 分享屏幕时的码流ID
+ (NSData *)sendRoomStartToShareWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId sharingType:(SharingType)sharingType sharingPicURL:(NSString *)sharingPicURL sharingRelativePicURL:(NSString *)sharingRelativePicURL sharingStreamId:(NSString *)sharingStreamId;

#pragma mark 停止分享(包括：白板、图片、桌面)
/// 停止分享(包括：白板、图片、桌面)
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
+ (NSData *)sendRoomStopSharingWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId;

#pragma mark 设置开启&关闭水印
/// 设置开启&关闭水印
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param isWaterMark YES-开启水印 NO-关闭水印
+ (NSData *)sendRoomWaterMarkWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId isWaterMark:(BOOL)isWaterMark;

#pragma mark 转移房间主持人权限
/// 转移房间主持人
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param targetId 目标用户
+ (NSData *)sendRoomMoveHostWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(NSString *)targetId;

#pragma mark 设置房间联席主持人权限
/// 设置房间联席主持人
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param targetId 目标用户
/// @param state 状态(YES-设置 NO-取消)
+ (NSData *)sendRoomUnionHostWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(NSString *)targetId state:(BOOL)state;

#pragma mark 回收房间主持人权限
/// 回收房间主持人权限
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param targetId 目标用户
+ (NSData *)sendRoomRecoveryHostWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId targetId:(nullable NSString *)targetId;

#pragma mark 设置房间静音状态
/// 设置房间静音状态
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param state 静音状态
+ (NSData *)sendRoomMuteWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId state:(MuteState)state;

#pragma mark 设置房间成员昵称
/// 设置房间成员昵称
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param targetId 目标用户ID
/// @param roomId 房间ID
/// @param nickname 目标昵称
+ (NSData *)sendRoomMemberNicknameWithSession:(NSString *)session accountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId nickname:(NSString *)nickname;

#pragma mark 设置房间是否允许自行解除禁音
/// 设置房间是否允许自行解除禁音
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
/// @param state  解除禁音状态
+ (NSData *)sendRoomRelieveAstateWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId state:(RelieveAstate)state;

#pragma mark 设置房间成员扩展字段
/// 设置房间成员扩展字段
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户标识
/// @param targetId 目标用户标识
/// @param roomId 房间标识
/// @param extendInfo 扩展信息
+ (NSData *)sendRoomChangeAccountExtendWithSession:(NSString *)session accountId:(NSString *)accountId targetId:(NSString *)targetId roomId:(NSString *)roomId extendInfo:(NSString *)extendInfo;

#pragma mark 设置触发房间同步账户信息
/// 设置触发房间同步账户信息
/// @param session 入会凭证 (互动凭证)
/// @param accountId 用户ID
/// @param roomId 房间ID
+ (NSData *)sendRoomTriggerAccountSynchronizationWithSession:(NSString *)session accountId:(NSString *)accountId roomId:(NSString *)roomId;

#pragma mark - 解析收到的互动服务消息
/// 解析收到的互动服务消息
/// @param receiveData 接收数据
/// @param resultBlock 结果回调
+ (void)receiveSocketData:(NSData *)receiveData resultBlock:(VCSChatRoomPackageBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
