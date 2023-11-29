//
//  RTYUVPlayer.h
//  AnyliveSDK
//
//  Created by huangkexing on 2019/8/15.
//  Copyright © 2019年 huangkexing. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RTYUVPlayer : UIView

/// 设置是否为画中画播放器，默认 否
@property (assign, nonatomic) BOOL isPictureInPicture;


#pragma mark - 重置布局
/// 重置布局
/// - Parameter set: YES-重新计算
- (void)SetLayoutReset:(BOOL)set;


#pragma mark - 渲染显示PixelBuffer数据[YUV]
/// 渲染显示PixelBuffer数据[YUV]
/// - Parameter pixelBuffer: 像素数据
- (int)displayCVPixleBuffer:(CVPixelBufferRef)pixelBuffer;

#pragma mark - 渲染显示YUV数据
/// 渲染显示YUV数据
/// - Parameters:
///   - track: 视频流轨道
///   - type: YUV数据类型(0-I420 1-NV12 2-NV21)
///   - lable: 视频流角度
///   - width: 视频流宽
///   - height: 视频流高
///   - yData: Y数据
///   - uData: U数据
///   - vData: V数据
- (int)displayYUVData:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;


#pragma mark - 开启支持视图缩放移动
/// 开启支持视图缩放移动
/// 当开启支持视图缩放移动，[使用 move:、zoom:、directZoom:、getCurrentScale 操作视图的移动和缩放]
/// - Parameter open: 是否开启，默认 不开启
- (void)openViewZoomAndMove:(BOOL)open;

#pragma mark - 平移视图
/// 平移视图
/// 开启支持视图缩放移动有效
/// - Parameters:
///   - dx: X轴偏移量
///   - dy: Y轴偏移量
- (void)move:(float)dx dy:(float)dy;

#pragma mark - 缩放视图
/// 缩放视图
/// 开启支持视图缩放移动有效
/// - Parameter scale: 缩放比例
- (void)zoom:(float)scale;

#pragma mark - 中心点缩放视图
/// 中心点缩放视图
/// 开启支持视图缩放移动有效
/// - Parameter scale: 缩放比例
- (void)directZoom:(float)scale;

#pragma mark - 获取当前的缩放比例
/// 获取当前的缩放比例
/// 开启支持视图缩放移动有效
- (float)getCurrentScale;


#pragma mark - 设置自定义显示控制模式
/// 设置自定义显示控制模式
/// 当开启自定义显示控制模式时，[使用 setViewScaleType:、setViewflip:、setViewRotate: 定义画面旋转角度、显示翻转以及显示模式]
/// - Parameter use: 是否开启，默认不开启
- (void)customDisplayCtrl:(BOOL)use;

#pragma mark - 设置画面旋转角度
/// 设置画面旋转角度
/// 当开启自定义显示控制模式时有效
/// - Parameter rotateAngle: 旋转角度
- (void)setViewRotate:(int)rotateAngle;

#pragma mark - 设置显示翻转
/// 设置显示翻转
/// 当开启自定义显示控制模式时有效
/// - Parameters:
///   - flipX: X轴翻转
///   - flipY: Y轴翻转
- (void)setViewflip:(BOOL)flipX flipY:(BOOL)flipY;

#pragma mark - 设置显示模式
/// 设置显示模式
/// 当开启自定义显示控制模式时有效
/// - Parameter ScaleType: 显示模式，默认 CENTERINSIDE，详情请参看 VCS_EVENT_TYPE 中的定义
- (void)setViewScaleType:(int)ScaleType;


#pragma mark - 清除像素
/// 清除像素
- (void)cleanpixels;

#pragma mark - 渲染完成
/// 渲染完成
/// 调用此方法时，播放器会立即渲染完成当前的任务，如果当前还有为完成的数据会被丢弃
- (void)renderFinish;

#pragma mark - 释放播放器
/// 释放播放器
- (void)ReleasePlay;

@end
