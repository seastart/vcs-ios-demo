//
//  FWPlayerView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/30.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VCSSDK/VCSSDK.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 流媒体采集回调
/// 流媒体采集结果回调(外部去根据流媒体ID 找到相对应的数据源 切换大小图 isMaxPlayer=YES大图 No小图)
/// @param serverId 流媒体ID
/// @param isMaxPlayer 切换大小图(YES-大图，NO-小图)
typedef void(^FWPlayerViewResultBlock)(NSString * _Nullable serverId, BOOL isMaxPlayer);

@interface FWPlayerView : UIView

#pragma mark resultBlock回调
@property (nonatomic, copy) FWPlayerViewResultBlock resultBlock;

#pragma mark 小窗口父组件
@property (nonatomic, strong) UIScrollView *scrollView;

#pragma mark 初始化视图
/// 初始化视图
/// @param frame 位置尺寸
- (instancetype)initSGWithFrame:(CGRect)frame;

#pragma mark - 更改屏幕方向
/// 更改屏幕方向
/// @param isHorizontalScreen YES-切换横屏 NO-切换竖屏
- (void)changeScreenOrientation:(BOOL)isHorizontalScreen;

#pragma mark - 我的视频发生变化处理
/// 我的视频发生变化处理
/// @param videoState 视频状态
- (void)stepVideoState:(BOOL)videoState;

#pragma mark - 我的音频发生变化处理
/// 我的音频发生变化处理
/// @param audioState 音频状态
- (void)stepAudioState:(BOOL)audioState;

#pragma mark - 当前有人在共享屏幕
/// 当前有人在共享屏幕
/// @param streamId 流媒体连接标识
/// @param isSharing 是否在共享
- (void)sharingDesktop:(NSString *)streamId isSharing:(BOOL)isSharing;

#pragma mark 有人进入房间
/// 有人进入房间
/// @param account 参会人信息
- (void)playEnterWithAccount:(Account *)account;

#pragma mark 有人离开房间
/// 有人离开房间
/// @param account 参会人信息
- (void)playLeaveWithAccount:(Account *)account;

#pragma mark 会议时成员状态更新
/// 会议时成员状态更新
/// @param account  参会人信息
- (void)playStateWithAccount:(Account *)account;

#pragma mark - 会议时成员音频变化更新
/// 会议时成员音频变化更新
/// @param audioArray 音频变化列表
- (void)playAudioWithAudioArray:(NSMutableArray *)audioArray;

#pragma mark - 用于播放用户的特定画面
/// 用于播放用户的特定画面
/// @param linkId 视频链路ID
/// @param stamp 时间戳
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)playCallbackFrameWithLinkId:(int)linkId stamp:(int)stamp track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;

#pragma mark 播放画面缩放
/// 播放画面缩放
/// @param scale 缩放比例
- (void)playerViewZoomWithScale:(float)scale;

#pragma mark - 播放画面直接缩放
/// 播放画面直接缩放
/// @param point 位置坐标
- (void)playerViewDirectZoom;

#pragma mark 播放画面拖动
/// 播放画面拖动
/// @param offsetX X轴坐标系的偏移值
/// @param offsetY Y轴坐标系的偏移值
- (void)playerViewMoveWithOffsetX:(float)offsetX offsetY:(float)offsetY;

@end

NS_ASSUME_NONNULL_END
