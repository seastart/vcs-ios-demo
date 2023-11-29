//
//  FWPackageBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/4/15.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 服务消息解析结果回调
/// 服务消息解析结果回调
/// @param type 报文类型
/// @param command 通知类型
/// @param result 结果
/// @param data 解析出的数据
typedef void(^FWPackageBridgeBlock)(int type, int command, int result, NSData *data);

@interface FWPackageBridge : NSObject

#pragma mark - 组装心跳数据包
/// 组装心跳数据包
/// @param token 登录token
/// @param accountId 账号ID
+ (NSData *)sendHeartBeatWithToken:(NSString *)token accountId:(NSString *)accountId;

#pragma mark - 解析收到的服务消息
/// 解析收到的服务消息
/// @param receiveData 接收数据
/// @param resultBlock 结果回调
+ (void)receiveSocketData:(NSData *)receiveData resultBlock:(FWPackageBridgeBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
