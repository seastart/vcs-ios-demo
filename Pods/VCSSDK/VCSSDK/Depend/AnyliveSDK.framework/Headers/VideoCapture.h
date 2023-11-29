//
//  VideoCapture.h
//  AnyliveSDK
//
//  Created by huangkexing on 2020/5/15.
//  Copyright © 2020年 huangkexing. All rights reserved.
//
#ifndef VideoCapture_h
#define VideoCapture_h
#define kWeakSelf        __weak typeof(self) weakSelf = self
#define kFCScreenWidth  ([UIScreen mainScreen ].bounds.size.width)
#define kFCScreenHeight ([UIScreen mainScreen ].bounds.size.height)
#import<UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol VideoCaptureDelegate<NSObject>
//采集出来的实际数据 //后面这个将代理SDK上层将不再需要维护
-(void)CameraVideoOutPut:(CVPixelBufferRef)pixelBuffer videoW:(int)videoWidth videH:(int)videoHeight stamp:(CMTime)stamp isFront:(BOOL)isFront viewChange:(int)viewChange;
//返回实际的采集大小
-(void)VideoRealSize:(int)imageWidth H:(int)imageHeight;
@end

@interface VideoCapture:NSObject
@property (nonatomic, weak) id<VideoCaptureDelegate> delegate;
-(VideoCapture*)Init;
//初始化采集 pView:预览的UIView size:预览View的大小
-(BOOL)InitVideoCapture:(UIView*)pView size:(CGSize)size;
//开启预览
-(void)startPreview;
//停止预览
-(void)stopPreview;
//启动采集
-(void)StartCapture;
//停止采集
-(void)StopCapture;
//释放采集
-(void)releaseCapture;
//设置大小 设置大小如果不支持那么SDK将会自动选择最接近的分辨率,在启动采集后 如果再次调用该函数，那么分辨率将会被设置成最新的分辨率
-(void)setCaptureSize:(int)OutWidth H:(int)OutHeight;
//设置前置后置摄像头【默认前置 】InitVideoCapture 前设置
-(void)setCaptureCameraPosition:(BOOL)Front;
//打开闪光灯
-(void)openTorch:(BOOL)open;
//设置曝光,范围【-8.0，8.0】;
-(void)setExpose:(float)value;
//镜头拉伸 【1.0，5.0】
-(void)setZoomFatory:(float)value;
//切换摄像头
-(void)changeCamera;
//启用自动闪光灯
-(void)setFlashAuto;
//判断前置摄像头是否可用
-(BOOL)isFrontCameraAvailable;
//判断后置摄像头是否可用
-(BOOL)isBackCameraAvailable;
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable;
//是否有多个摄像头
- (BOOL) hasMultipleCameras;
//获取实际的采集大小
-(CGSize)getRealCaptureSize;
//手动聚焦
-(void)setfocusAtPoint:(CGPoint)point;
//调整preview  当预览窗口变化时调用该接口函数
-(void)updatePreviewSize:(CGSize)size;
//预览方向
-(void)updatePreviewOrientation:(UIDeviceOrientation)deviceOrientation;

- (void)updatePreviewMirror:(BOOL)isMirror;
//0 is front 1 isback
-(int)getCurrenCameraId;
//set camera FPS
-(void)setCameraFps:(int)fps;
@end
#endif /* VideoCapture_h */

