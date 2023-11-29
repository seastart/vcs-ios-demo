//
//  VCSCameraGatherManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import <AnyliveSDK/AnyliveSDK.h>
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 本地采集实例相关代理
@protocol VCSCameraGatherManagerDelegate <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark 点击视频流窗口
/// 点击视频流窗口
/// @param tag 标记
/// @param tapCount 双击&单击
- (void)cameraViewTouchWithTag:(CGFloat)tag tapcount:(int)tapCount;

#pragma mark 实际的采集大小
/// 实际的采集大小
/// @param imageWidth 视频宽
/// @param imageHeight 视频高
- (void)captureVideoRealWithWidth:(int)imageWidth height:(int)imageHeight;

#pragma mark 摄像头采集视频数据回调
/// 摄像头采集视频数据回调
/// @param pixelbuffer 视频采集数据
- (void)captureCameraDataWithCVPixleBuffer:(CVPixelBufferRef)pixelbuffer;

@end

@interface VCSCameraGatherManager : NSObject

#pragma mark 本地采集实例相关代理
@property (nonatomic, weak) id <VCSCameraGatherManagerDelegate> delegate;


#pragma mark - -------- 本地采集基础接口 ---------
#pragma mark 单例模式初始化本地采集实例
/// 单例模式初始化本地采集实例
+ (VCSCameraGatherManager *)sharedManager;

#pragma mark 初始化本地采集实例
/// 初始化本地采集实例
- (void)initCameraGather;

#pragma mark 释放本地采集资源
/// 释放本地采集资源
- (void)destroy;


#pragma mark - -------- 视频采集变换接口 --------
#pragma mark 却换屏幕方向
/// 却换屏幕方向
/// @param orientation 预览画面方向
/// @param previewSize 预览画面尺寸
- (void)changeScreenOrientation:(UIDeviceOrientation)orientation previewSize:(CGSize)previewSize;

#pragma mark 加载采集实例
/// 加载采集实例
/// @param displayView 预览播放器
- (void)onLocalDisplayViewReady:(RTYUVPlayer *)displayView;

#pragma mark 获取本地预览播放器
/// 获取本地预览播放器
- (nullable RTYUVPlayer *)localPreview;

#pragma mark 开启摄像头预览和采集
/// 开启摄像头预览和采集
- (void)startCapture;

#pragma mark 停止摄像头预览和采集
/// 停止摄像头预览和采集
- (void)stopCapture;

#pragma mark 设置视频曝光率
/// 设置视频曝光率
/// @param value 曝光值(-8.0~8.0)
- (void)setVideoExposure:(float)value;

#pragma mark 设置镜头拉伸
/// 设置镜头拉伸
/// @param value 拉伸值(1.0~5.0)
- (void)setCameraZoomFatory:(float)value;

#pragma mark 切换摄像头(前置or后置)
/// 切换摄像头(前置or后置)
- (void)switchCamera;

#pragma mark 打开/关闭闪光灯
/// 打开/关闭闪光灯
/// @param isOpen YES-打开 NO-关闭
- (void)flashlightCamera:(BOOL)isOpen;

#pragma mark 启用自动闪光灯
/// 启用自动闪光灯
- (void)setFlashlightAuto;

#pragma mark 判断前置摄像头是否可用
/// 判断前置摄像头是否可用
- (BOOL)isFrontCameraAvailable;

#pragma mark 判断后置摄像头是否可用
/// 判断后置摄像头是否可用
- (BOOL)isBackCameraAvailable;

#pragma mark 判断设备是否有摄像头
/// 判断设备是否有摄像头
- (BOOL)isCameraAvailable;

#pragma mark 判断设备是否有多个摄像头
/// 判断设备是否有多个摄像头
- (BOOL)hasMultipleCameras;

#pragma mark 获取实际的采集大小
/// 获取实际的采集大小
- (CGSize)getRealCaptureSize;

#pragma mark 手动聚焦
/// 手动聚焦
/// @param point 标点
- (void)setFocusAtPoint:(CGPoint)point;

#pragma mark 设置画面预览方向
/// 设置画面预览方向
/// @param deviceOrientation 预览方向
- (void)setPreviewOrientation:(UIDeviceOrientation)deviceOrientation;

#pragma mark - 手动修正预览界面
/// 手动修正预览界面
/// @param size 大小
- (void)revisePreviewSize:(CGSize)size;

#pragma mark - 设置是否开启预览镜像
/// 设置是否开启预览镜像
/// @param isMirror 是否开启
- (void)setPreviewMirror:(BOOL)isMirror;

#pragma mark - 获取当前摄像头
/// 获取当前摄像头 0-代表前置 1-代表后置
- (int)getCurrenCamera;

@end

NS_ASSUME_NONNULL_END
