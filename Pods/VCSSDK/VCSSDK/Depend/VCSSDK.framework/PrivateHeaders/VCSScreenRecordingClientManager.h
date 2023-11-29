//
//  VCSScreenRecordingClientManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/6/11.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
#import <hkScreenShared/hkScreenShared.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^VCSScreenClientCloseBlock)(NSString * _Nullable errorMsg);

@interface VCSScreenRecordingClientManager : NSObject

#pragma mark - -------- 屏幕录制被调用端基础接口 ---------
#pragma mark 单例模式初始化屏幕录制被调用端实例
/// 单例模式初始化屏幕录制被调用端实例
+ (VCSScreenRecordingClientManager *)sharedManager;

#pragma mark - 开启录制被调用端(编码模式)
/// 开启录制被调用端(编码模式)
/// @param closeBlock 被调用端关闭回调
- (void)startEncoderScreenRecordingClient:(VCSScreenClientCloseBlock)closeBlock;

#pragma mark - 开启录制被调用端(非编码模式)
/// 开启录制被调用端(非编码模式)
/// @param closeBlock 被调用端关闭回调
- (void)startScreenRecordingClient:(VCSScreenClientCloseBlock)closeBlock;

#pragma mark - 发送共享屏幕帧数据
/// 发送共享屏幕帧数据
/// @param sampleBuffer 帧数据
/// @param sampleBufferType 帧数据类型
- (void)sendSampleBufferServer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType;

@end

NS_ASSUME_NONNULL_END
