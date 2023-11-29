//
//  VCSChatRoomManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import "VCSCommons.h"
#import "Models.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSChatRoomManager;

#pragma mark - SDK互动服务相关代理
@protocol VCSChatRoomManagerDelegate <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark 互动服务监听结果回调方法
/// 互动服务监听结果回调方法
/// @param command cmd指令
/// @param result 结果
- (void)roomInteractiveListenWithCommand:(Command)command result:(Result)result;

#pragma mark 互动服务闪断重连成功回调
/// 互动服务闪断重连成功回调
- (BOOL)roomReconnectedSucceed;

#pragma mark 监听互动服务消息
/// 监听互动服务消息
/// @param command 消息类型
/// @param result 结果
/// @param data 消息体
/// @param firstNotify 是否为首次状态通知
- (void)roomListenMessageWithCommand:(Command)command result:(Result)result data:(NSData *)data firstNotify:(BOOL)firstNotify;

@end

/// 释放完成回调
typedef void (^VCSChatRoomManagerDestroyBlock)(void);

@interface VCSChatRoomManager : NSObject

#pragma mark 互动服务相关代理
@property (nonatomic, weak) id <VCSChatRoomManagerDelegate> delegate;

#pragma mark Socket连接状态
@property (nonatomic, assign) BOOL isSocketConnect;

#pragma mark 进入房间状态
/// 进入房间状态
@property (nonatomic, assign) BOOL isEnterRoom;

#pragma mark - -------- 互动服务基础接口 ---------
#pragma mark 单例模式初始化互动服务实例
/// 单例模式初始化互动服务实例
+ (VCSChatRoomManager *)sharedManager;

#pragma mark 互动服务连接
/// 互动服务连接
- (BOOL)servicConnect;

#pragma mark 重连互动服务
/// 重连互动服务
/// @param restart 是否需要重置订阅
- (BOOL)restartConnect:(BOOL)restart;

#pragma mark 关闭Socket连接
/// 关闭Socket连接
- (void)closeSocket;

#pragma mark 释放互动服务资源
/// 释放互动服务资源
/// @param finishBlock 释放完成回调
- (void)destroy:(VCSChatRoomManagerDestroyBlock)finishBlock;


#pragma mark - -------- 发送互动服务消息 --------
#pragma mark 发送心跳消息
/// 发送心跳消息
- (void)sendHeartBeat;

#pragma mark 发送退出房间消息
- (void)sendExitRoom;

#pragma mark 发送聊天消息
/// 发送文本消息
/// @param message 消息内容
/// @param targetId 目标用户ID(不传代表发送给会议室全体人员)
/// @param type 消息类型
- (void)sendTextChatWithMessage:(nullable NSString *)message targetId:(nullable NSString *)targetId type:(MessageType)type;

#pragma mark 发送主持人踢人消息
/// 发送主持人踢人消息
/// @param targetId 目标用户ID(返回NO 代表没有权限执行此操作)
- (void)sendKickoutWithTargetId:(nullable NSString *)targetId;

#pragma mark 发送主持人禁用/关闭/开启音频消息
/// 发送主持人禁用/开启音频消息
/// @param targetId 目标用户ID(为空时代表全局禁用)
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlAudioWithTargetId:(nullable NSString *)targetId audioState:(DeviceState)audioState;

#pragma mark 发送主持人禁用/关闭/开启视频消息
/// 发送主持人禁用/开启视频消息
/// @param targetId 目标用户ID(为空时代表全局禁用)
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlVideoWithTargetId:(nullable NSString *)targetId videoState:(DeviceState)videoState;

#pragma mark 发送主持人操作成员音频消息
/// 发送主持人操作成员音频消息
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlMemberAudioWithTargetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray audioState:(DeviceState)audioState;

#pragma mark 发送主持人操作成员视频消息
/// 发送主持人操作成员视频消息
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlMemberVideoWithTargetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray videoState:(DeviceState)videoState;

#pragma mark 发送主持人操作房间音频消息
/// 发送主持人操作房间音频消息
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlRoomAudioWithAudioState:(DeviceState)audioState;

#pragma mark 发送主持人操作房间视频消息
/// 发送主持人操作房间视频消息
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlRoomVideoWithVideoState:(DeviceState)videoState;

#pragma mark 主持人设置白板状态(打开或关闭)[废弃]
/// 主持人设置白板状态(打开或关闭)[废弃]
/// @param openState 是否打开状态(YES-打开，NO-关闭)
- (void)setRoomWhiteBoardStateWithOpenState:(BOOL)openState;

#pragma mark 推送码流发生变化
/// 推送码流发生变化
/// @param operation 操作指令(Operation_OperationRemove-移除，Operation_OperationAdd-添加，Operation_OperationUpdate-更新)
/// @param stream 码流信息
- (void)changedRoomStreamWithOperation:(Operation)operation stream:(Stream *)stream;

#pragma mark 发送透传消息(自定义消息)
/// 发送透传消息(自定义消息)
/// @param targetId 目标用户
/// @param message 自定义消息
- (void)sendRoomPassthroughWithTargetId:(NSString *)targetId message:(NSString *)message;

#pragma mark 主持人变更码流
/// 主持人变更码流
/// @param targetId 目标用户
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息
- (void)hostChangedRoomStreamWithTargetId:(NSString *)targetId operation:(Operation)operation stream:(Stream *)stream;

#pragma mark 主持人处理举手
/// 主持人处理举手
/// @param targetId 目标用户
/// @param hus 举手类型(HandUpStatus_HusNone-无，HandUpStatus_HusLiftTheBan-解除禁言请求)
/// @param result 处理结果(YES-同意，NO-不同意)
- (void)hostDisposeRoomRaiseHandWithTargetId:(NSString *)targetId hus:(HandUpStatus)hus result:(BOOL)result;

#pragma mark 开始分享(包括：白板、图片、桌面)
/// 开始分享(包括：白板、图片、桌面)
/// @param sharingType 分享类型
/// @param sharingPicURL 分享图片时的图片地址
/// @param sharingRelativePicURL 分享图片时的图片相对地址
- (void)sendRoomStartToShareWithSharingType:(SharingType)sharingType sharingPicURL:(nullable NSString *)sharingPicURL sharingRelativePicURL:(nullable NSString *)sharingRelativePicURL;

#pragma mark 停止分享(包括：白板、图片、桌面)
/// 停止分享(包括：白板、图片、桌面)
- (void)sendRoomStopSharing;

#pragma mark 设置开启&关闭水印
/// 设置开启&关闭水印
/// @param openState YES-开启水印 NO-关闭水印
- (void)sendRoomWaterMarkWithOpenState:(BOOL)openState;

#pragma mark 转移房间主持人权限
/// 转移房间主持人权限
/// @param targetId 目标用户
- (void)sendRoomMoveHostWithTargetId:(NSString *)targetId;

#pragma mark 设置房间联席主持人权限
/// 设置房间联席主持人权限
/// @param targetId 目标用户
/// @param state 状态(YES-设置 NO-回收)
- (void)sendRoomUnionHostWithTargetId:(NSString *)targetId state:(BOOL)state;

#pragma mark 回收房间主持人权限
/// 回收房间主持人权限
/// @param targetId 目标用户
- (void)sendRoomRecoveryHostWithTargetId:(nullable NSString *)targetId;

#pragma mark 设置房间静音状态
/// 设置房间静音状态
/// @param state 静音状态
- (void)sendRoomMuteWithState:(MuteState)state;

#pragma mark 设置房间成员昵称
/// 设置房间成员昵称
/// @param targetId 目标用户ID
/// @param nickname 目标昵称
- (void)sendRoomMemberNicknameWithTargetId:(NSString *)targetId nickname:(NSString *)nickname;

#pragma mark 设置房间是否允许自行解除禁音
/// 设置房间是否允许自行解除禁音
/// @param state 0-允许解除禁音 1-不允许解除禁音
- (void)sendRoomRelieveAstateWithState:(RelieveAstate)state;

#pragma mark 设置房间成员扩展信息
/// 设置房间成员扩展信息
/// - Parameters:
///   - targetId: 目标用户标识
///   - extendInfo: 扩展信息
- (void)sendRoomMemberExtendWithTargetId:(NSString *)targetId extendInfo:(NSString *)extendInfo;

@end

NS_ASSUME_NONNULL_END
