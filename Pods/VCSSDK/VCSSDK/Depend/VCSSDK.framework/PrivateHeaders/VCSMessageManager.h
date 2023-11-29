//
//  VCSMessageManager.h
//  ActionSheetPicker-3.0
//
//  Created by SailorGa on 2023/4/11.
//

#import <Foundation/Foundation.h>
#import "VCSMQTTManager.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ------------ 通讯组件回调 ------------
#pragma mark 操作结果回调
/// 操作结果回调
/// @param error 错误信息
typedef void (^VCSMessageManagerResultBlock)(NSError *error);

#pragma mark 连接状态回调
/// 连接状态回调
/// @param state 连接状态
typedef void (^VCSMessageManagerChangeStateBlock)(SGMQTTSessionManagerState state);

#pragma mark 接收数据回调
/// 接收数据回调
/// @param data 数据
/// @param topic 主题
typedef void(^VCSMessageManagerReceiveDataBlock)(NSData *data, NSString *topic);


@interface VCSMessageManager : NSObject

+ (instancetype)new __attribute__((unavailable("Use +sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("Use +sharedInstance instead")));


#pragma mark - ------------ Core Service ------------

#pragma mark 连接状态回调
/// 连接状态回调
/// 注：当网络异常导致重连成功后，需要取消并重新订阅相关主题
@property (nonatomic, copy) VCSMessageManagerChangeStateBlock changeStateBlock;

#pragma mark 获取单例
/// 获取单例
+ (VCSMessageManager *)sharedInstance;

#pragma mark 订阅主题
/// 订阅主题
/// - Parameters:
///   - topic: 目标主题
///   - qosLevel: Qos等级
///   - resultBlock: 操作结果回调
///   - receiveDataBlock: 接收数据回调
- (void)subscribeMessageWithTopic:(NSString *)topic qosLevel:(SGMQTTQosLevel)qosLevel resultBlock:(nullable VCSMessageManagerResultBlock)resultBlock receiveDataBlock:(nullable VCSMessageManagerReceiveDataBlock)receiveDataBlock;

#pragma mark 取消订阅主题
/// 取消订阅主题
/// - Parameters:
///   - topic: 目标主题
///   - resultBlock: 操作结果回调
- (void)unsubscribeMessageWithTopic:(NSString *)topic resultBlock:(nullable VCSMessageManagerResultBlock)resultBlock;

#pragma mark 发送数据
/// 发送数据
/// - Parameters:
///   - topic: 目标主题
///   - qosLevel: Qos等级
///   - data: 发送数据
///   - resultBlock: 操作结果回调
- (void)publishMessageWithTopic:(NSString *)topic qosLevel:(SGMQTTQosLevel)qosLevel data:(NSData *)data resultBlock:(nullable VCSMessageManagerResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
