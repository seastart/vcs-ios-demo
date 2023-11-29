//
//  FWRoomConfigViewModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VCSSDK/VCSSDK.h>
#import "FWLoginModel.h"
#import "FWEnterRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWRoomConfigViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 房间号码
@property (copy, nonatomic) NSString *roomNumberText;
/// AGC
@property (copy, nonatomic) NSString *agcText;
/// AEC
@property (copy, nonatomic) NSString *aecText;
/// 音频采样率
@property (copy, nonatomic) NSString *sampeText;
/// 帧率
@property (copy, nonatomic) NSString *fpsText;
/// 帧率
@property (copy, nonatomic) NSString *vbirateText;
/// 调试地址
@property (copy, nonatomic) NSString *debugAddrText;
/// 提示
@property (copy, nonatomic) NSString *promptText;

/// 远程调试开关
/// NO-调试开关关闭状态，YES-调试开关开启状态
@property (assign, nonatomic) BOOL isDebug;
/// 硬件编码开关
/// NO-硬编码关闭状态，YES-硬编码开启状态
@property (assign, nonatomic) BOOL isHardware;
/// 自己视频开关
/// NO-自己视频开启状态，YES-自己视频关闭状态
@property (assign, nonatomic) BOOL isThisVideo;
/// 自己音频开关
/// NO-自己音频开启状态，YES-自己音频关闭状态
@property (assign, nonatomic) BOOL isThisAudio;
/// 他人视频开关
/// NO-接收他人视频，YES-不接收他人视频
@property (assign, nonatomic) BOOL isOtherVideo;
/// 他人音频开关
/// NO-接收他人音频，YES-不接收他人音频
@property (assign, nonatomic) BOOL isOtherAudio;
/// 码率自适应开关
/// NO-码率自适应开启状态，YES-码率自适应关闭状态
@property (assign, nonatomic) BOOL isBitRateAdaptation;
/// 延时自适应开关
/// NO-延时自适应开启状态，YES-延时自适应关闭状态
@property (assign, nonatomic) BOOL isDelayAdaptation;
/// 播放声音状态
/// NO-关闭声音，YES-开启声音
@property (assign, nonatomic) BOOL isOpenSpeaker;

/// 音频是否是AAC编码
@property (assign, nonatomic) BOOL isAudioEncodeAac;

/// 进入房间请求订阅
@property (nonatomic, strong, readonly) RACSubject *enterRoomSubject;

/// 登录信息
@property (nonatomic, strong) FWLoginModel *loginModel;
/// 进入房间信息
@property (nonatomic, strong) FWEnterRoomModel *enterRoomModel;
/// 会议配置信息
@property (nonatomic, strong) VCSMeetingParam *meetingParam;

/// 开始会议
- (void)startMeeting;

@end

NS_ASSUME_NONNULL_END
