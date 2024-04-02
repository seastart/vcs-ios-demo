//
//  FWLoggerBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2022/9/30.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import "FWLoggerBridge.h"

@interface FWLoggerBridge () <VCSLoggerManagerDelegate>

@end

@implementation FWLoggerBridge

#pragma mark 初始化方法
/// 初始化方法
+ (FWLoggerBridge *)sharedManager {
    
    static FWLoggerBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWLoggerBridge alloc] init];
    });
    return manager;
}

#pragma mark 启动日志服务
/// 启动日志服务
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
///   - deviceId: 设备标识
- (void)startLogger:(NSString *)domainUrl secretKey:(NSString *)secretKey deviceId:(NSString *)deviceId {
    
    /// 启动日志服务
    [[VCSLoggerManager sharedManager] startLogger:domainUrl secretKey:secretKey deviceId:deviceId delegate:self];
}

#pragma mark 变更服务地址
/// 变更服务地址
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
- (void)changeDomainUrl:(NSString *)domainUrl secretKey:(NSString *)secretKey {
    
    /// 变更服务地址
    [[VCSLoggerManager sharedManager] changeDomainUrl:domainUrl secretKey:secretKey];
}

#pragma mark 追加行为日志
/// 追加行为日志
/// - Parameters:
///   - logLevel: 日志等级
///   - logType: 日志类型
///   - moduleName: 模块名称
///   - moduleId: 模块标识
///   - params: 日志内容
- (void)appendLoggerWithLevel:(VCSLoggerLevel)logLevel logType:(NSString *)logType moduleName:(nullable NSString *)moduleName moduleId:(nullable NSString *)moduleId params:(id)params {
    
    /// 创建行为日志对象
    VCSLoggerItemModel *itemModel = [[VCSLoggerItemModel alloc] initWithServerity:logLevel type:logType mname:moduleName mid:moduleId body:params];
    /// 追加启动日志
    [[VCSLoggerManager sharedManager] appendLoggerWithItemModel:itemModel];
}

#pragma mark 触发日志上报
/// 触发日志上报
- (void)triggerUpload {
    
    /// 触发日志上报
    [[VCSLoggerManager sharedManager] triggerUpload];
}

#pragma mark - ----- VCSLoggerManagerDelegate代理方法 -----
#pragma mark 行为日志扩展事件回调
/// 行为日志扩展事件回调
/// - Parameters:
///   - manager: 日志组件实例
///   - loggerParam: 行为日志对象
- (VCSLoggerItemModel *)loggerManager:(VCSLoggerManager *)manager onLoggerExpand:(VCSLoggerItemModel *)itemModel {
    
    /// 补充用户标识
    itemModel.uid = @"Your User Id";
    /// 补充用户名称
    itemModel.uname = @"Your User Name";
    
    /// 返回扩展后数据
    return itemModel;
}

#pragma mark 实时日志扩展事件回调
/// 实时日志扩展事件回调
/// - Parameters:
///   - manager: 日志组件实例
///   - object: 实时日志对象
- (VCSMetricItemModel *)loggerManager:(VCSLoggerManager *)manager onMetricExpand:(VCSMetricItemModel *)itemModel {
    
    /// 补充会议日志标识
    itemModel.conf_log_id = @"Your Meeting Log Id";
    /// 补充参会记录标识
    itemModel.trace_id = @"Your Join Meeting Log Id";
    
    /// 返回扩展后数据
    return itemModel;
}

#pragma mark 重定向日志扩展事件回调
/// 重定向日志扩展事件回调
/// - Parameters:
///   - manager: 日志组件实例
///   - redirectModel: 重定向日志对象
- (VCSRedirectModel *)loggerManager:(VCSLoggerManager *)manager onRedirectExpand:(VCSRedirectModel *)redirectModel {
    
    /// 补充用户标识
    redirectModel.uid = @"Your User Id";
    /// 补充会议日志标识
    redirectModel.conf_log_id = @"Your Meeting Log Id";
    
    /// 返回扩展后数据
    return redirectModel;
}

@end
