//
//  VCSNetworkManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VCSNetworkManager;
@class VCSNetworkConfig;
@class VCSNetworkModel;
@class VCSNetworkConnectModel;

#pragma mark - 网络检测服务相关代理
@protocol VCSNetworkManagerDelegate <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark - ----- Core Delegate Methods -----

#pragma mark 开启网络检测
/// 开启网络检测
/// @param networkManager 网络检测对象
- (void)networkManagerDidBegined:(nonnull VCSNetworkManager *)networkManager;

#pragma mark 完成网络检测
/// 完成网络检测
/// @param networkManager 网络检测对象
/// @param uploadModel 上行网络状况
/// @param downModel 下行网络状况
/// @param connectModel 网络连接状况
- (void)networkManagerDidFinshed:(nonnull VCSNetworkManager *)networkManager uploadModel:(nullable VCSNetworkModel *)uploadModel downModel:(nullable VCSNetworkModel *)downModel connectModel:(VCSNetworkConnectModel *)connectModel;

@end

@interface VCSNetworkManager : NSObject

#pragma mark - -------- 网络检测服务基础接口 ---------
#pragma mark 单例模式获取网络检测服务实例
/// 单例模式获取网络检测服务实例
+ (VCSNetworkManager *)sharedManager;

#pragma mark 开启网络监测
/// 开启网络监测
/// @param config 检测配置
/// @param delegate 回调代理
- (BOOL)startDetectionWithConfig:(nonnull VCSNetworkConfig *)config delegate:(id <VCSNetworkManagerDelegate>)delegate;

#pragma mark 停止网络监测
/// 停止网络监测
- (void)stopNetworkDetection;

@end

NS_ASSUME_NONNULL_END
