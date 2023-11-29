//
//  VCSNetworkQosBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2022/9/28.
//

#import <Foundation/Foundation.h>
#import "VCSNetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSNetworkQosBridge : NSObject

#pragma mark - 单例获取网络检测工具示例
/// 单例获取网络检测工具示例
+ (VCSNetworkQosBridge *)sharedManager;

#pragma mark - 恢复初始设置
/// 恢复初始设置
- (void)setup;

#pragma mark - 单次网络检测结果处理
/// 单次网络检测结果处理
/// @param result 单次检测结果
/// @param replacing 需要替换的字符串
/// @param upload 是否为上行
- (void)networkDetectionSingleWithResult:(NSString *)result replacing:(NSString *)replacing upload:(BOOL)upload;

#pragma mark - 最终上行网络检测结果处理
/// 最终上行网络检测结果处理
- (nullable VCSNetworkModel *)networkUploadFinally;

#pragma mark - 最终下行网络检测结果处理
/// 最终下行网络检测结果处理
- (nullable VCSNetworkModel * )networkDownFinally;

#pragma mark - 最终网络检测结果处理
/// 最终网络检测结果处理
/// @param dataArray 单次检测结果列表
- (nullable VCSNetworkModel *)networkDetectionFinallyWithDataArray:(NSArray<VCSNetworkModel *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
