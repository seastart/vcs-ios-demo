//
//  FWLoggerBridge.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2022/9/30.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VCSSDK/VCSLogger.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWLoggerBridge : NSObject

#pragma mark 初始化方法
/// 初始化方法
+ (FWLoggerBridge *)sharedManager;

#pragma mark 启动日志服务
/// 启动日志服务
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
///   - deviceId: 设备标识
- (void)startLogger:(NSString *)domainUrl secretKey:(NSString *)secretKey deviceId:(NSString *)deviceId;

#pragma mark 变更服务地址
/// 变更服务地址
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
- (void)changeDomainUrl:(NSString *)domainUrl secretKey:(NSString *)secretKey;

#pragma mark 追加行为日志
/// 追加行为日志
/// - Parameters:
///   - logLevel: 日志等级
///   - logType: 日志类型
///   - moduleName: 模块名称
///   - moduleId: 模块标识
///   - params: 日志内容
- (void)appendLoggerWithLevel:(VCSLoggerLevel)logLevel logType:(NSString *)logType moduleName:(nullable NSString *)moduleName moduleId:(nullable NSString *)moduleId params:(id)params;

#pragma mark 触发日志上报
/// 触发日志上报
- (void)triggerUpload;

@end

NS_ASSUME_NONNULL_END
