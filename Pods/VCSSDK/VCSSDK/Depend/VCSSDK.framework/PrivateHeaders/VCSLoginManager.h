//
//  VCSLoginManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 操作结果回调
typedef void (^VCSLoginManagerResultBlock)(NSError * _Nullable error);

@interface VCSLoginManager : NSObject

#pragma mark - -------- 登录服务基础接口 ---------
#pragma mark 单例模式获取登录服务实例
/// 单例模式获取登录服务实例
+ (VCSLoginManager *)sharedManager;

#pragma mark - 登录操作
/// 登录操作
/// @param token 登录token
/// @param meetingHost 连接地址
/// @param meetingPort 连接端口
/// @param serverId 注册服务器ID
/// @param timeoutInterval 超时时间
/// @param resultBlock 登录结果回调
- (void)login:(NSString *)token meetingHost:(NSString *)meetingHost meetingPort:(NSInteger)meetingPort serverId:(NSString *)serverId timeoutInterval:(NSTimeInterval)timeoutInterval resultBlock:(nullable VCSLoginManagerResultBlock)resultBlock;

#pragma mark - 退出登录
/// 退出登录
- (void)logout;

#pragma mark - 服务连接状态
/// 服务连接状态
@property (nonatomic, assign, readonly) BOOL isServeConnect;

#pragma mark - 登录token
/// 登录token
@property (nonatomic, copy) NSString *token;

#pragma mark - 连接地址
/// 连接地址
@property (nonatomic, copy) NSString *meetingHost;

#pragma mark - 连接端口
/// 连接端口
@property (nonatomic, assign) NSInteger meetingPort;

#pragma mark 注册服务器ID
/// 注册服务器ID
@property (nonatomic, copy) NSString *serverId;

@end

NS_ASSUME_NONNULL_END
