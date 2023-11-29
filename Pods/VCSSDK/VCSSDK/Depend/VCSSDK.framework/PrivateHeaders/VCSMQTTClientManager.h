//
//  VCSMQTTClientManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "RoomServer.pbobjc.h"
#import "Register.pbobjc.h"
#import "Models.pbobjc.h"
#import "VCSCommons.h"
#import "VCSMQTTClientManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSMQTTClientManager : NSObject

#pragma mark 信令服务连接状态
/// 信令服务连接状态
@property (nonatomic, assign) BOOL signalingConnect;

#pragma mark 呼叫服务相关代理
/// 呼叫服务相关代理
@property (nonatomic, weak) id <VCSMQTTClientManagerProtocol> delegate;

#pragma mark - -------- 呼叫服务基础接口 ---------
#pragma mark 单例模式获取呼叫服务实例
/// 单例模式获取呼叫服务实例
+ (VCSMQTTClientManager *)sharedManager;

#pragma mark 获取呼叫服务版本号
/// 获取呼叫服务版本号
- (NSString *)version;

#pragma mark 获取呼叫服务版本信息
/// 获取呼叫服务版本信息
- (NSString *)getVersionInfo;

#pragma mark 连接呼叫服务
/// 连接呼叫服务
/// @param accountId 帐号ID
/// @param name 帐号姓名
/// @param nickname 帐号昵称
/// @param portrait 帐号头像
/// @param delegate 代理设置
- (void)startNetCallWithAccountId:(NSString *)accountId name:(NSString *)name nickname:(NSString *)nickname portrait:(NSString *)portrait delegate:(id <VCSMQTTClientManagerProtocol>)delegate;

#pragma mark 更新账号信息
/// 更新账号信息
/// @param accountId 帐号ID
/// @param name 帐号姓名
/// @param nickname 帐号昵称
/// @param portrait 帐号头像
- (void)changeMineInfoWithAccountId:(nullable NSString *)accountId name:(nullable NSString *)name nickname:(nullable NSString *)nickname portrait:(nullable NSString *)portrait;

#pragma mark 销毁释放呼叫服务资源
/// 销毁释放呼叫服务资源
- (void)destroy;

#pragma mark - -------- 呼叫服务业务接口 ---------
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

#pragma mark 取消呼叫(废弃)
/// 取消呼叫(废弃)
/// @param accountsArray 取消呼叫列表
/// @param roomNo 房间ID
- (void)callCancelWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray roomNo:(NSString *)roomNo DEPRECATED_MSG_ATTRIBUTE("此方法已经弃用，请迁移到callCancelNewWithAccountsArray:roomNo:接口");

#pragma mark 从呼叫中移除(废弃)
/// 从呼叫中移除(废弃)
/// @param targetIdArray 目标用户ID列表(空集合则取消所有人)
/// @param roomNo 房间ID
- (void)callRemoveWithTargetIdArray:(nullable NSMutableArray<NSString *> *)targetIdArray roomNo:(NSString *)roomNo DEPRECATED_MSG_ATTRIBUTE("此方法已经弃用，请迁移到callRemoveNewWithAccountsArray:roomNo:接口");

#pragma mark 取消呼叫(新增)
/// 取消呼叫(新增)
/// @param accountsArray 取消呼叫列表
/// @param roomNo 房间ID
- (void)callCancelNewWithAccountsArray:(nullable NSMutableArray<WaitingAccount *> *)accountsArray roomNo:(NSString *)roomNo;

#pragma mark 从呼叫中移除(新增)
/// 从呼叫中移除(新增)
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
- (ImBody *)sendTextWithMessage:(NSString *)message receiverID:(NSString *)receiverID;

#pragma mark 发送群聊文本消息
/// 发送群聊文本消息
/// @param message 文本消息
/// @param groupID 群组ID
- (ImBody *)sendTextGroupWithMessage:(NSString *)message groupID:(NSString *)groupID;

#pragma mark 发送单聊图片消息
/// 发送群聊图片消息
/// @param imagePath 图片地址
/// @param receiverID 接收者ID
- (ImBody *)sendImageWithImagePath:(NSString *)imagePath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊图片消息
/// 发送单聊图片消息
/// @param imagePath 图片地址
/// @param groupID 群组ID
- (ImBody *)sendImageGroupWithImagePath:(NSString *)imagePath groupID:(NSString *)groupID;

#pragma mark 发送单聊语音消息
/// 发送单聊语音消息
/// @param audioPath 语音地址
/// @param receiverID 接收者ID
- (ImBody *)sendAudioWithAudioPath:(NSString *)audioPath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊语音消息
/// 发送单聊语音消息
/// @param audioPath 语音地址
/// @param groupID 群组ID
- (ImBody *)sendAudioGroupWithAudioPath:(NSString *)audioPath groupID:(NSString *)groupID;

#pragma mark 发送单聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param receiverID 接收者ID
- (ImBody *)sendVideoWithVideoPath:(NSString *)videoPath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊视频消息
/// 发送单聊视频消息
/// @param videoPath 视频地址
/// @param groupID 群组ID
- (ImBody *)sendVideoGroupWithVideoPath:(NSString *)videoPath groupID:(NSString *)groupID;

#pragma mark 发送单聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param receiverID 接收者ID
- (ImBody *)sendFileWithFilePath:(NSString *)filePath receiverID:(NSString *)receiverID;

#pragma mark 发送群聊文件消息
/// 发送单聊文件消息
/// @param filePath 文件地址
/// @param groupID 群组ID
- (ImBody *)sendFileGroupWithFilePath:(NSString *)filePath groupID:(NSString *)groupID;

@end

NS_ASSUME_NONNULL_END
