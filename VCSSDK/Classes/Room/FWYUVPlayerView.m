//
//  FWYUVPlayerView.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/30.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWYUVPlayerView.h"

@interface FWYUVPlayerView ()

/// 内容
@property (weak, nonatomic) IBOutlet UIView *contentView;
/// 视频窗口
@property (weak, nonatomic) IBOutlet UIView *playerView;
/// 视频状态显示
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
/// 音频状态显示
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;
/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 视频关闭提示
@property (weak, nonatomic) IBOutlet UILabel *videoCloseLabel;

/// 切换一号轨道(0视频轨)
@property (weak, nonatomic) IBOutlet UIButton *streamTrackButtonOne;
/// 切换二号轨道(1视频轨)
@property (weak, nonatomic) IBOutlet UIButton *streamTrackButtonTwo;
/// 切换三号轨道(2视频轨)
@property (weak, nonatomic) IBOutlet UIButton *streamTrackButtontThree;
/// 切换四号轨道(0视频轨和1视频轨)
@property (weak, nonatomic) IBOutlet UIButton *streamTrackButtonFour;

/// 音量柱
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgressView;

/// 当前是否在共享
@property (assign, nonatomic) BOOL isSharing;

/// 窗口对应用户信息
@property (nonatomic, strong) Account *account;
/// 实例播放SDK信息
@property (nonatomic, strong) RTYUVPlayer *player;

@end

@implementation FWYUVPlayerView

#pragma mark 初始化视图
/// 初始化视图
/// @param frame 位置尺寸
/// @param account 窗口对应用户信息
- (instancetype)initSGWithFrame:(CGRect)frame account:(Account *)account {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.contentView];
        /// 设置属性
        [self stepConfig:account];
    }
    return self;
}

#pragma mark - 设置属性
- (void)stepConfig:(Account *)account {
    
    /// 保存窗口关联用户信息
    self.account = account;
    /// 默认没有在共享
    self.isSharing = NO;
    /// 绑定动态响应信号
    [self bindSignal];
    /// 实例播放器
    [self.playerView addSubview:self.player];
    /// 设置窗口信息
    [self playStateWithAccount:account];
}

#pragma mark - 懒加载实例播放
- (RTYUVPlayer *)player {
    
    if (!_player) {
        _player = [[RTYUVPlayer alloc] initWithFrame:self.bounds];
        _player.backgroundColor = [UIColor clearColor];
    }
    return _player;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /// 设置播放组件frame
    self.player.frame = self.bounds;
    /// 不全屏显示需要计算坐标位置
    [self.player SetLayoutReset:YES];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    /// 踢出按钮事件
    [[self.kickoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self sendKickoutMessage];
    }];
    
    /// 主持人禁言按钮事件
    [[self.forbiddenAudioButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self sendKostCtrlAudioMessage];
    }];
    
    /// 主持人禁视频按钮事件
    [[self.forbiddenVideoButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [self sendKostCtrlVideoMessage];
    }];
    
    /// 是否接收该视频流按钮事件
    [[self.streamVideoInceptButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.streamVideoInceptButton.selected = !self.streamVideoInceptButton.selected;
        if (self.streamVideoInceptButton.selected) {
            [[VCSMeetingManager sharedManager] enableRecvVideoWithClientId:self.account.streamId besidesId:nil enabled:NO];
        } else {
            [[VCSMeetingManager sharedManager] enableRecvVideoWithClientId:self.account.streamId besidesId:nil enabled:YES];
        }
    }];
    
    /// 是否接收该音频流按钮事件
    [[self.streamAudioInceptButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.streamAudioInceptButton.selected = !self.streamAudioInceptButton.selected;
        if (self.streamAudioInceptButton.selected) {
            /// [[VCSMeetingManager sharedManager] enableRecvAudioWithClientId:self.account.streamId enabled:NO];
        } else {
            /// [[VCSMeetingManager sharedManager] enableRecvAudioWithClientId:self.account.streamId enabled:YES];
        }
    }];
    
    /// 切换一号轨道(0视频轨)按钮事件
    [[self.streamTrackButtonOne rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [FWToastBridge showToastAction:@"已切换到0轨道"];
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.account.streamId mark:1 isSync:NO];
    }];
    
    /// 切换二号轨道(1视频轨)按钮事件
    [[self.streamTrackButtonTwo rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [FWToastBridge showToastAction:@"已切换到1轨道"];
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.account.streamId mark:2 isSync:NO];
    }];
    
    /// 切换三号轨道(2视频轨)按钮事件
    [[self.streamTrackButtontThree rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [FWToastBridge showToastAction:@"已切换到2轨道"];
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.account.streamId mark:4 isSync:NO];
    }];
    
    /// 切换四号轨道(0视频轨和1视频轨)按钮事件
    [[self.streamTrackButtonFour rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        [FWToastBridge showToastAction:@"已切换到0~1轨道"];
        [[VCSMeetingManager sharedManager] setStreamTrackWithClientId:self.account.streamId mark:3 isSync:NO];
    }];
}

#pragma mark - 主持人踢人消息
- (void)sendKickoutMessage {
    
    [[VCSMeetingManager sharedManager] sendKickoutWithTargetId:self.account.id_p];
}

#pragma mark - 主持人禁用/开启音频消息(音频和视频单独设置状态时，另一个状态参数不需要传)
#pragma mark 主持人禁用/开启音频消息
- (void)sendKostCtrlAudioMessage {
    
    /// 更改按钮状态
    self.forbiddenAudioButton.selected = !self.forbiddenAudioButton.selected;
    
    [[VCSMeetingManager sharedManager] sendKostCtrlMemberAudioWithTargetidsArray:@[self.account.id_p].mutableCopy audioState:self.forbiddenAudioButton.selected ? DeviceState_DsDisabled : DeviceState_DsActive];
}

#pragma mark 主持人禁用/开启视频消息
- (void)sendKostCtrlVideoMessage {
    
    /// 更改按钮状态
    self.forbiddenVideoButton.selected = !self.forbiddenVideoButton.selected;
    
    [[VCSMeetingManager sharedManager] sendKostCtrlMemberVideoWithTargetidsArray:@[self.account.id_p].mutableCopy videoState:self.forbiddenVideoButton.selected ? DeviceState_DsDisabled : DeviceState_DsActive];
}

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
- (void)playCallbackFrameWithLinkId:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData {
    
    /// 显示画面
    int errorCode = [self.player displayYUVData:track type:type lable:lable width:width height:height yData:yData uData:uData vData:vData];
    
    if (errorCode < 0) {
        /// 渲染成员视频数据失败
        VCSLOG(@"渲染成员视频数据失败 errorCode = %d", errorCode);
    }
    
    /// 释放流媒体像素数据资源
    if (yData) {
        free(yData);
    }
    if (uData) {
        free(uData);
    }
    if (vData) {
        free(vData);
    }
}

#pragma mark 会议时成员状态更新
/// 会议时成员状态更新
/// @param account  参会人信息
- (void)playStateWithAccount:(Account *)account {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /// 保存窗口关联用户信息
        self.account = account;
        /// SGLOG(@"++++++与会人员状态更新，可是处理与会人员的音频、视频等状态切换 Account = %@", account);
        /// 设置标题
        /// self.titleLabel.text = account.nickname;
        self.titleLabel.text = [NSString stringWithFormat:@"%@\n%d", account.nickname, account.streamId];
        
        /// 设置音频状态
        if (account.hasAudioState) {
            if (account.audioState == DeviceState_DsActive) {
                self.audioImageView.hidden = YES;
            } else {
                /// 主持人禁言或者自己关闭音频
                self.audioImageView.hidden = NO;
            }
        } else {
            self.audioImageView.hidden = YES;
        }
        
        if (self.isSharing) {
            return;
        }
        /// 设置视频状态
        if (account.hasVideoState) {
            if (account.videoState == DeviceState_DsActive) {
                self.videoImageView.hidden = YES;
                self.videoCloseLabel.hidden = YES;
            } else {
                /// 主持人禁视频或者自己关闭视频
                self.videoImageView.hidden = NO;
                self.videoCloseLabel.hidden = NO;
            }
        } else {
            self.videoImageView.hidden = YES;
            self.videoCloseLabel.hidden = YES;
        }
    });
}

#pragma mark 设置当前音频分贝
/// 设置当前音频分贝
/// @param volume 分贝值
- (void)playAudioWithVolume:(float)volume {
    
    SGLOG(@"+++++++设置的分贝值为 = %f", volume);
    /// 设置音量柱数值
    [self.audioProgressView setProgress:volume animated:YES];
}

#pragma mark - 当前有人在共享屏幕
/// 当前有人在共享屏幕
/// @param isSharing 是否在共享
- (void)sharingDesktop:(BOOL)isSharing {
    
    /// 记录共享状态
    self.isSharing = isSharing;
    if (self.isSharing) {
        self.videoImageView.hidden = YES;
        self.videoCloseLabel.hidden = YES;
    }
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 释放RTYUVPlayer资源
    [self.player ReleasePlay];
    SGLOG(@"++++++++++++释放资源：%@", kStringFromClass(self));
}

@end
