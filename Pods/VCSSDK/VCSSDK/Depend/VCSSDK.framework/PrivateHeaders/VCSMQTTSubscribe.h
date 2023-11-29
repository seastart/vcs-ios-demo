//
//  VCSMQTTSubscribe.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "SGMQTTClient.h"

/// MQTT连接订阅对象
NS_ASSUME_NONNULL_BEGIN

/// MQTT接收数据回调
typedef void(^VCSMQTTReceiveDataHandler)(SGMQTTSessionManager *sessionManager, NSData *data, NSString *topic, BOOL retained);

@interface VCSMQTTSubscribe : NSObject

/// 订阅主题
@property (nonatomic, copy) NSString *topic;
/// 服务质量级别
@property (nonatomic, assign) SGMQTTQosLevel qos;
/// 接收数据回调
@property (nonatomic, copy) VCSMQTTReceiveDataHandler handler;
/// 订阅主题(订阅主题---服务质量级别)
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *subscription;

/// 初始化连接订阅对象
/// @param topic 订阅主题
/// @param qos 服务质量级别
/// @param handler 接收数据回调
- (instancetype)initWithTopic:(NSString *)topic qos:(SGMQTTQosLevel)qos handler:(VCSMQTTReceiveDataHandler)handler;

#pragma mark - 检测订阅对象是否为该主题
/// 检测订阅对象是否为该主题
/// @param topic 订阅主题
- (BOOL)containsWithTopic:(NSString *)topic;

@end

NS_ASSUME_NONNULL_END
