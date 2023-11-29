//
//  VCSMQTTManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "VCSMQTTManagerBuilder.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MQTT错误码
/**
 MQTT错误码
 
 - VCSMQTTManagerStateSubscribe: 订阅主题失败
 - VCSMQTTManagerStateUnsubscribe: 取消订阅失败
 */
typedef enum : NSInteger {
    
    VCSMQTTManagerStateSubscribe = 108,
    VCSMQTTManagerStateUnsubscribe = 110
} VCSMQTTManagerState;

@interface VCSMQTTManager : NSObject

/// 单例初始化方法
+ (VCSMQTTManager *)sharedManager;

/// 指定要连接到的主机名或IP地址。默认 @"localhost"
@property (nonatomic, copy, readonly) VCSMQTTManager * (^host)(NSString *);
/// 指定要连接到的端口。默认 1883
@property (nonatomic, copy, readonly) VCSMQTTManager * (^port)(NSInteger);
/// 指定是否使用SSL协议。默认 NO
@property (nonatomic, copy, readonly) VCSMQTTManager * (^tls)(BOOL);
/// 指定心跳时间(单位秒)。默认 60
@property (nonatomic, copy, readonly) VCSMQTTManager * (^keepalive)(NSInteger);
/// 指定服务器是否应该丢弃以前的会话信息。默认 YES
@property (nonatomic, copy, readonly) VCSMQTTManager * (^clean)(BOOL);
/// 指定是否使用登录验证，和下面的user和pass参数组合使用。默认 NO
@property (nonatomic, copy, readonly) VCSMQTTManager * (^auth)(BOOL);
/// 指定用户名进行身份验证。默认 nil
@property (nonatomic, copy, readonly) VCSMQTTManager * (^user)(NSString *);
/// 指定用户密码进行身份验证。默认 nil
@property (nonatomic, copy, readonly) VCSMQTTManager * (^pass)(NSString *);
/// 指示是否应发送离线消息。默认 YES
@property (nonatomic, copy, readonly) VCSMQTTManager * (^will)(BOOL);
/// 发送离线消息订阅的主题。默认 @"willTopic"
@property (nonatomic, copy, readonly) VCSMQTTManager * (^willTopic)(NSString *);
/// 发送离线消息的自定义格式。默认 @"offline"
@property (nonatomic, copy, readonly) VCSMQTTManager * (^willMsg)(NSData *);
/// 指定在发送离线消息时要使用的服务质量级别。默认 SGMQTTQosLevelExactlyOnce
@property (nonatomic, copy, readonly) VCSMQTTManager * (^willQos)(SGMQTTQosLevel);
/// 指示服务器是否使用retainFlag发布离线消息。默认 NO
@property (nonatomic, copy, readonly) VCSMQTTManager * (^willRetainFlag)(BOOL);
/// 客户端全局唯一标识符，服务端是根据这个来区分不同的客户端的。
/// 假如有另外的连接以这个ID登录，上一个连接会被踢下线。
/// 如果为nil，则生成一个随机的clientId。默认 @""
@property (nonatomic, copy, readonly) VCSMQTTManager * (^clientId)(NSString *);
/// 指示定制SSL安全策略可以为空。默认 [MQTTSSLSecurityPolicy defaultPolicy](不要使用固定证书来验证服务器。)
@property (nonatomic, copy, readonly) VCSMQTTManager * (^securityPolicy)(SGMQTTSSLSecurityPolicy *);
/// 指示需要使用固定的证书可以为空。默认 nil
@property (nonatomic, copy, readonly) VCSMQTTManager * (^certificates)(NSArray *);
/// 指示连接的协议版本。默认SGMQTTProtocolVersion311
@property (nonatomic, copy, readonly) VCSMQTTManager * (^protocolLevel)(SGMQTTProtocolVersion);
/// 指示会话过期间隔。默认 300s
@property (nonatomic, copy, readonly) VCSMQTTManager * (^expiryInterval)(NSNumber *);

/// 指示MQTTSession的运行循环。默认[NSRunLoop currentRunLoop]
@property (nonatomic, copy, readonly) VCSMQTTManager * (^runLoop)(NSRunLoop *);

/// 重置配置信息
@property (nonatomic, copy, readonly) VCSMQTTManager * (^reset)(void);


/// 请求连接
@property (nonatomic, copy, readonly) VCSMQTTManager * (^connect)(SGMQTTConnectHandler);

/// 断开连接
@property (nonatomic, copy, readonly) VCSMQTTManager * (^disConnect)(SGMQTTDisconnectHandler);

/// 订阅主题
@property (nonatomic, copy, readonly) VCSMQTTManager * (^subscribe)(NSString *topic, SGMQTTQosLevel level, SGMQTTSubscribeHandler result, VCSMQTTReceiveDataHandler receiveData);

/// 取消订阅
@property (nonatomic, copy, readonly) VCSMQTTManager * (^unsubscribe)(NSString *topic, SGMQTTUnsubscribeHandler handler);

/// 发送数据
@property (nonatomic, copy, readonly) VCSMQTTManager * (^publishData)(NSData *data, NSString *topic, BOOL retain, SGMQTTQosLevel qos, SGMQTTPublishHandler handler);

/// 添加接收数据监听
@property (nonatomic, copy, readonly) VCSMQTTManager * (^addReceive)(NSString *label, VCSMQTTReceiveDataHandler handler);

/// 移除接收数据监听
@property (nonatomic, copy, readonly) VCSMQTTManager * (^removeReceive)(NSString *label);

/// 连接状态改变监听
@property (nonatomic, copy, readonly) VCSMQTTManager * (^addChangeState)(NSString *label, VCSMQTTDidChangeStateHandler handler);

/// 移除连接状态改变的监听
@property (nonatomic, copy, readonly) VCSMQTTManager * (^removeChangeState)(NSString *label);

@end

NS_ASSUME_NONNULL_END
