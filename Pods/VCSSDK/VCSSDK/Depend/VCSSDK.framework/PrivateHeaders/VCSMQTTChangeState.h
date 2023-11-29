//
//  VCSMQTTChangeState.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "SGMQTTClient.h"

/// MQTT连接状态对象
NS_ASSUME_NONNULL_BEGIN

/// MQTT连接状态变更回调
typedef void(^VCSMQTTDidChangeStateHandler)(SGMQTTSessionManager *sessionManager, SGMQTTSessionManagerState newState);

@interface VCSMQTTChangeState : NSObject

/// 标签名
@property (nonatomic, copy) NSString *label;
/// 连接状态变更回调
@property (nonatomic, copy) VCSMQTTDidChangeStateHandler handler;

/// 初始化连接状态对象
/// @param label 标签名
/// @param handler 连接状态变更回调
- (instancetype)initWithLabel:(NSString *)label handler:(VCSMQTTDidChangeStateHandler)handler;

@end

NS_ASSUME_NONNULL_END
