//
//  VCSAudioManagerProtocol.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/24.
//

#import <AVFoundation/AVFoundation.h>

#pragma mark - 录音服务相关代理
@protocol VCSAudioManagerProtocol <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark - -------- 录音相关 ---------
#pragma mark 开始录制
/// 开始录音
- (void)recordBegined;

#pragma mark 录制完成
/// 录制完成
- (void)recordFinshed;

#pragma mark 正在录音中，录音音量监测
/// 正在录音中，录音音量监测
/// @param volume 音量(0~1)
- (void)recordingVoiceWithVolume:(double)volume;

#pragma mark 正中录音中，是否录音倒计时、录音剩余时长
/// 正中录音中，是否录音倒计时、录音剩余时长
/// @param time 录音剩余时长
/// @param isTimer 是否录音倒计时
- (void)recordingWithResidualTime:(NSTimeInterval)time timer:(BOOL)isTimer;


#pragma mark - -------- 播放相关 ---------
#pragma mark 开始播放音频
/// 开始播放音频
/// @param state 状态(加载中、加载失败、加载成功正在播放、未知)
/// @param playerItem 播放载体
- (void)audioPlayBeginedWithState:(AVPlayerItemStatus)state playerItem:(AVPlayerItem *)playerItem;

#pragma mark 正在播放音频
/// 正在播放音频
/// @param totalTime 总时长
/// @param currentTime 当前时长
- (void)audioPlayingWithTotalTime:(NSTimeInterval)totalTime time:(NSTimeInterval)currentTime;

#pragma mark 音频播放完成
/// 音频播放完成
- (void)audioPlayFinished;

@end
