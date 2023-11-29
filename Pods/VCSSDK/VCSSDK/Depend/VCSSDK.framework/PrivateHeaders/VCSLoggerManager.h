//
//  VCSLoggerManager.h
//  VCSSDK
//
//  Created by SailorGa on 2022/9/26.
//

#import <Foundation/Foundation.h>
#import "VCSLoggerObjects.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSLoggerManager;

#pragma mark - 日志事件回调
@protocol VCSLoggerManagerDelegate <NSObject>
#pragma mark 可选实现代理方法
@optional

#pragma mark - ----- Core Delegate Methods -----
#pragma mark 行为日志扩展事件回调
/// 行为日志扩展事件回调
/// - Parameters:
///   - manager: 日志组件实例
///   - itemModel: 行为日志对象
- (VCSLoggerItemModel *)loggerManager:(VCSLoggerManager *)manager onLoggerExpand:(VCSLoggerItemModel *)itemModel;

#pragma mark 实时日志扩展事件回调
/// 实时日志扩展事件回调
/// - Parameters:
///   - manager: 日志组件实例
///   - itemModel: 实时日志对象
- (VCSMetricItemModel *)loggerManager:(VCSLoggerManager *)manager onMetricExpand:(VCSMetricItemModel *)itemModel;

@end

#pragma mark - VCSLoggerManager
@interface VCSLoggerManager : NSObject

+ (instancetype)new __attribute__((unavailable("Use +sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("Use +sharedInstance instead")));

#pragma mark - ------------ Core Service ------------

/// 日志事件代理
@property (nonatomic, weak) id<VCSLoggerManagerDelegate> delegate;
/// 绑定会议号码
@property (nonatomic, strong, readonly) NSString *roomNo;
/// 日志服务是否启用
@property (nonatomic, assign, readonly) BOOL serviceEnabled;

#pragma mark 获取日志组件实例
/// 获取日志组件实例
+ (VCSLoggerManager *)sharedManager;

#pragma mark 日志组件版本
///  日志组件版本
- (NSString *)version;

#pragma mark 启动日志服务
/// 启动日志服务
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
///   - delegate: 日志代理
- (void)startLogger:(NSString *)domainUrl secretKey:(NSString *)secretKey delegate:(nullable id <VCSLoggerManagerDelegate>)delegate;

#pragma mark 启动日志服务
/// 启动日志服务
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
///   - deviceId: 设备标识
///   - delegate: 日志代理
- (void)startLogger:(NSString *)domainUrl secretKey:(NSString *)secretKey deviceId:(NSString *)deviceId delegate:(nullable id <VCSLoggerManagerDelegate>)delegate;

#pragma mark 变更服务地址
/// 变更服务地址
/// - Parameters:
///   - domainUrl: 服务地址
///   - secretKey: 服务密钥
- (void)changeDomainUrl:(NSString *)domainUrl secretKey:(NSString *)secretKey;

#pragma mark 追加行为日志
/// 追加行为日志
/// - Parameter itemModel: 行为日志对象
- (void)appendLoggerWithItemModel:(VCSLoggerItemModel *)itemModel;

#pragma mark 追加实时日志
/// 追加实时日志
/// - Parameter itemModel: 实时日志对象
- (void)appendMetricWithItemModel:(VCSMetricItemModel *)itemModel;

#pragma mark 触发日志上报
/// 触发日志上报
- (void)triggerUpload;

#pragma mark 是否启用日志上报
/// 是否启用日志上报
/// - Parameter enabled: Yes-启用  No-关闭
- (void)enableUploadLogs:(BOOL)enabled;

#pragma mark 绑定会议号码
/// 绑定会议号码
/// - Parameter roomNo: 会议号码
- (void)bindRoomNo:(nullable NSString *)roomNo;

#pragma mark 追加打印日志
/// 追加打印日志
/// - Parameter format: 版式串
+ (void)LOGGER:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end

NS_ASSUME_NONNULL_END
