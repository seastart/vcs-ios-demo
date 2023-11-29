//
//  VCSAudioTimerBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSAudioTimerBridge : NSObject

#pragma mark - 音频计时器初始化
/// 音频计时器初始化
/// @param timeInterval 时间间隔
/// @param userInfo 信息
/// @param repeat 是否重复
/// @param target 目标
/// @param selector 活动
NSTimer *VCSAudioTimerInitialize(NSTimeInterval timeInterval, __nullable id userInfo, BOOL repeat, id target, SEL selector);

#pragma mark - 音频计时器启动
/// 音频计时器启动
/// @param timer 计时器
void VCSAudioTimerStart(NSTimer *timer);

#pragma mark - 音频计时器停止
/// 音频计时器停止
/// @param timer 计时器
void VCSAudioTimerStop(NSTimer *timer);

#pragma mark - 音频计时器释放
/// 音频计时器释放
/// @param timer 计时器
void VCSAudioTimerKill(NSTimer *timer);

@end

NS_ASSUME_NONNULL_END
