//
//  FWPackageBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2023/4/15.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <VCSSDK/Register.pbobjc.h>
#import <VCSSDK/VCSMessage.h>
#import <VCSSDK/VCSPacket.h>
#import "FWPackageBridge.h"

@implementation FWPackageBridge

#pragma mark - 组装心跳数据包
/// 组装心跳数据包
/// @param token 登录token
/// @param accountId 账号ID
+ (NSData *)sendHeartBeatWithToken:(NSString *)token accountId:(NSString *)accountId {
    
    RegHeartbeatRequest *request = [[RegHeartbeatRequest alloc] init];
    request.token = token;
    request.accountId = accountId;
    /// 数据回传发送
    NSData *socketData = [request data];
    /// 此处仅限提供示例使用，正式环境需要替换约定的Command值
    /// Command_CmdRegHeartbeat(1000)
    VCSPacket pack(1000, (const char *)[socketData bytes], socketData.length, 1, 0, 0, 0);
    std::string socket;
    pack.to_bytes_array(socket);
    return [NSData dataWithBytes:socket.c_str() length:socket.size()];
}

#pragma mark - 解析收到的服务消息
/// 解析收到的服务消息
/// @param receiveData 接收数据
/// @param resultBlock 结果回调
+ (void)receiveSocketData:(NSData *)receiveData resultBlock:(FWPackageBridgeBlock)resultBlock {
    
    /// 数据回传发送
    VCSPacket packet;
    VCSPacket::parse((const char *)[receiveData bytes], (int)receiveData.length, 0, &packet);
    std::string socket = packet.data();
    NSData *data = [NSData dataWithBytes:socket.c_str() length:socket.size()];
    /// 结果回调
    if (resultBlock) {
        resultBlock((int)packet.type(), (int)packet.command(), (int)packet.result(), data);
    }
}

@end
