//
//  VCSScreenRecordingServerManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 屏幕录制服务相关代理
@protocol VCSScreenRecordingServerManagerDelegate <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark 录屏状态码回调
/// 录屏状态码回调
/// @param status 状态码(0-停止，1-开始，-1-连接失败)
- (void)pushScreenStreamProcessStatus:(int)status;

@end

@interface VCSScreenRecordingServerManager : NSObject

#pragma mark 屏幕录制服务相关代理
@property (nonatomic, weak) id <VCSScreenRecordingServerManagerDelegate> delegate;

#pragma mark - -------- 屏幕录制基础接口 ---------
#pragma mark 单例模式初始化屏幕录制实例
/// 单例模式初始化屏幕录制实例
+ (VCSScreenRecordingServerManager *)sharedManager;

#pragma mark 获取屏幕录制扩展版本
/// 获取屏幕录制扩展版本
- (NSString *)getVersion;

#pragma mark - 开启录制调用端(编码模式)
/// 开启录制调用端(编码模式)
- (void)startEncoderScreenRecordingServer;

#pragma mark - 开启录制调用端(非编码模式)
/// 开启录制调用端(非编码模式)
- (void)startScreenRecordingServer;

#pragma mark - 关闭本次录屏服务
/// 关闭本次录屏服务
- (void)closeScreenServer;

#pragma mark 释放录屏服务资源
/// 释放录屏服务资源
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
