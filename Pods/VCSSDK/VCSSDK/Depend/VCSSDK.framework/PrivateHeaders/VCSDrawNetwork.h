//
//  VCSDrawNetwork.h
//  Draw
//
//  Created by seastart on 2020/8/1.
//  Copyright © 2020 seastart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCSEwbClient.h"
#import "Ewb.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSDrawNetwork : NSObject
{
    VCSEwbClient client; // 网络连接
}

// 回调方法
@property (nonatomic, copy) void (^onPacketBlock)(NSData* data, short command);

// 超时回调方法
@property (nonatomic, copy) void (^onTimeoutBlock)(bool connected);

// 获取单例
+ (instancetype)share;

// 关闭单例
+ (void)close;

// 获取网络对象
- (VCSEwbClient&)getClient;

// 回调函数
void onPacket(VCSEwbPacket* packet, void* context);

// 超时回调函数
void onTimeout(bool connected);

@end

NS_ASSUME_NONNULL_END
