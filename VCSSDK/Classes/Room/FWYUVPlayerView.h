//
//  FWYUVPlayerView.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/30.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VCSSDK/VCSSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWYUVPlayerView : UIView

/// 踢出按钮(主持人踢人)
@property (weak, nonatomic) IBOutlet UIButton *kickoutButton;
/// 禁言按钮(主持人禁言)
@property (weak, nonatomic) IBOutlet UIButton *forbiddenAudioButton;
/// 禁视频按钮(主持人禁视频)
@property (weak, nonatomic) IBOutlet UIButton *forbiddenVideoButton;
/// 接收视频流按钮
@property (weak, nonatomic) IBOutlet UIButton *streamVideoInceptButton;
/// 接收音频流按钮
@property (weak, nonatomic) IBOutlet UIButton *streamAudioInceptButton;

#pragma mark 是否是大图 默认小图
@property (nonatomic, assign) BOOL isMaxPlayer;

#pragma mark 初始化视图
/// 初始化视图
/// @param frame 位置尺寸
/// @param account 窗口对应用户信息
- (instancetype)initSGWithFrame:(CGRect)frame account:(Account *)account;

#pragma mark 用于播放用户的特定画面
/// 用于播放用户的特定画面
/// @param linkId 视频链路ID
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)playCallbackFrameWithLinkId:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;

#pragma mark 会议时成员状态更新
/// 会议时成员状态更新
/// @param account  参会人信息
- (void)playStateWithAccount:(Account *)account;

#pragma mark 设置当前音频分贝
/// 设置当前音频分贝
/// @param volume 分贝值
- (void)playAudioWithVolume:(float)volume;

#pragma mark - 当前有人在共享屏幕
/// 当前有人在共享屏幕
/// @param isSharing 是否在共享
- (void)sharingDesktop:(BOOL)isSharing;

@end

NS_ASSUME_NONNULL_END
