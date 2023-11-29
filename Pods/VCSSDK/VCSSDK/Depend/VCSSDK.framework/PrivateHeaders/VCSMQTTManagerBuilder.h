//
//  VCSMQTTManagerBuilder.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "VCSMQTTChangeState.h"
#import "VCSMQTTSubscribe.h"

/// MQTT会话管理构建器
NS_ASSUME_NONNULL_BEGIN

@interface VCSMQTTManagerBuilder : NSObject

/// 指定要连接到的主机名或IP地址。默认 @"localhost"
@property (nonatomic, copy) NSString *host;

/// 指定要连接到的端口。默认 1883
@property (nonatomic, assign) NSInteger port;

/// 指定是否使用SSL协议。默认 NO
@property (nonatomic, assign) BOOL tls;

/// 指定心跳时间(单位秒)。默认 60
@property (nonatomic, assign) NSInteger keepalive;

/// 指定服务器是否应该丢弃以前的会话信息。默认 YES
@property (nonatomic, assign) BOOL clean;

/// 指定是否使用登录验证，和下面的user和pass参数组合使用。默认 NO
@property (nonatomic, assign) BOOL auth;

/// 指定用户名进行身份验证。默认 nil
@property (nonatomic, copy) NSString *user;

/// 指定用户密码进行身份验证。默认 nil
@property (nonatomic, copy) NSString *pass;

/// 指示是否应发送离线消息。默认 YES
@property (nonatomic, assign) BOOL will;

/// 发送离线消息订阅的主题。默认 @"willTopic"
@property (nonatomic, copy) NSString *willTopic;

/// 发送离线消息的自定义格式。默认 @"offline"
@property (nonatomic, strong) NSData *willMsg;

/// 指定在发送离线消息时要使用的服务质量级别。默认 SGMQTTQosLevelExactlyOnce
@property (nonatomic, assign) SGMQTTQosLevel willQos;

/// 指示服务器是否使用retainFlag发布离线消息。默认 NO
@property (nonatomic, assign) BOOL willRetainFlag;

/// 客户端全局唯一标识符，服务端是根据这个来区分不同的客户端的。
/// 假如有另外的连接以这个ID登录，上一个连接会被踢下线。
/// 如果为nil，则生成一个随机的clientId。默认 @""
@property (nonatomic, copy) NSString *clientId;

/// 指示定制SSL安全策略可以为空。默认 [SGMQTTSSLSecurityPolicy defaultPolicy](不要使用固定证书来验证服务器。)
@property (nonatomic, strong) SGMQTTSSLSecurityPolicy *securityPolicy;

/// 指示需要使用固定的证书可以为空。默认 nil
@property (nonatomic, strong) NSArray *certificates;

/// 指示连接的协议版本。默认SGMQTTProtocolVersion311
@property (nonatomic, assign) SGMQTTProtocolVersion protocolLevel;

/// 指示会话过期间隔，MQTT5,0之后版本有效。默认 300s
@property (nonatomic, strong) NSNumber *expiryInterval;

/// 指示MQTTSession的运行循环。默认[NSRunLoop currentRunLoop]
@property (nonatomic, strong) NSRunLoop *runLoop;

/// 订阅主题(订阅主题---服务质量级别)
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *subscriptions;

/// 重置配置信息
- (void)reset;

/// 添加订阅主题
/// @param topic 订阅主题
/// @param qos 服务质量级别
/// @param handler 接收数据回调
- (void)addSubscribeWithTopic:(NSString *)topic qos:(SGMQTTQosLevel)qos handler:(VCSMQTTReceiveDataHandler)handler;

/// 移除订阅主题
/// @param topic 订阅主题
- (void)removeSubscribeWithTopic:(NSString *)topic;


/// 添加接收数据监听
/// @param receiveLabel 接收标签名
/// @param handler 接收数据回调
- (void)addReceiveWithLabel:(NSString *)receiveLabel handler:(VCSMQTTReceiveDataHandler)handler;

/// 移除接收数据监听
/// @param receiveLabel 接收标签名
- (void)removeReceiveWithLabel:(NSString *)receiveLabel;


/// 添加连接状态改变监听
/// @param label 标签名
/// @param handler 连接状态变更回调
- (void)addChangeStateWithLabel:(NSString *)label handler:(VCSMQTTDidChangeStateHandler)handler;

/// 移除连接状态改变监听
/// @param label 标签名
- (void)removeChangeStateWithLabel:(NSString *)label;


/// 执行接收数据处理会话管理器
/// @param sessionManager 会话管理器
/// @param data 接收数据
/// @param topic 订阅主题
/// @param retained 保留字段
- (void)excuteReceiveDataHandlerSessionManager:(SGMQTTSessionManager *)sessionManager data:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained;

/// 执行连接状态变更会话管理器
/// @param sessionManager 会话管理器
/// @param newState 连接状态
- (void)excuteDidChangeStateSessionManager:(SGMQTTSessionManager *)sessionManager newState:(SGMQTTSessionManagerState)newState;

@end

NS_ASSUME_NONNULL_END
