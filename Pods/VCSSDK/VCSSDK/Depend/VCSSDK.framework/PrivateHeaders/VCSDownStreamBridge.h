//
//  VCSDownStreamBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^VCSDownStreamBridgeChangeBlock)(VCSDownLevelState state);
typedef void (^VCSDownStreamBridgeAverageBlock)(CGFloat lrdAverage);

@interface VCSDownStreamBridge : NSObject

#pragma mark - 单例获取下行流媒体工具示例
/// 单例获取下行流媒体工具示例
+ (VCSDownStreamBridge *)sharedManager;

#pragma mark - 恢复初始设置
/// 恢复初始设置
- (void)setup;

#pragma mark - 综合换算下行网络档位等级
/// 综合换算下行网络档位等级
/// @param streamData 下行流媒体信息
/// @param changeBlock 档位变化回调
/// @param averageBlock 平均下行丢包率回调
- (void)onDownLevelWithStreamData:(NSDictionary *)streamData changeBlock:(VCSDownStreamBridgeChangeBlock)changeBlock averageBlock:(VCSDownStreamBridgeAverageBlock)averageBlock;

@end

NS_ASSUME_NONNULL_END
