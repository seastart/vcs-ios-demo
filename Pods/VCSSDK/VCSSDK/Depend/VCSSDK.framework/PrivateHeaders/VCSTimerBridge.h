//
//  VCSTimerBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSTimerBridge : NSObject

/// 创建计时器
/// @param interval 计时器间隔
/// @param inmilli 以毫秒为单位
/// @param repeats 是否重复
/// @param queue 工作队列
/// @param block 计时回调
+ (VCSTimerBridge *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval inmilli:(BOOL)inmilli repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block;

/// 释放计时器
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
