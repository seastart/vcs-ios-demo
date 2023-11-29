//
//  FWRoomConfigViewModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWRoomConfigViewModel.h"

@interface FWRoomConfigViewModel()

@end

@implementation FWRoomConfigViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _enterRoomSubject = [RACSubject subject];
        _loading = NO;
        _isDebug = NO;
        _isHardware = YES;
        _isThisVideo = NO;
        _isThisAudio = NO;
        _isOtherVideo = NO;
        _isOtherAudio = NO;
        _isBitRateAdaptation = NO;
        _isDelayAdaptation = NO;
        _isAudioEncodeAac = YES;
        _isOpenSpeaker = YES;
    }
    return self;
}

#pragma mark - 懒加载会议配置信息
- (VCSMeetingParam *)meetingParam {

    if (!_meetingParam) {
        _meetingParam = [[VCSMeetingParam alloc] init];
    }
    return _meetingParam;
}

#pragma mark - 开始会议
- (void)startMeeting {
    
    if (kStringIsEmpty(self.roomNumberText)) {
        self.promptText = @"请输入房间号码";
        return;
    }
    self.loading = YES;
    self.promptText = @"正在进入会议...";
    
    /// 当前登录人员信息
    self.meetingParam.currentSdkNo = (int)self.loginModel.data.account.room.sdk_no;
    self.meetingParam.accountId = self.loginModel.data.account.id;
    self.meetingParam.name = self.loginModel.data.account.name;
    self.meetingParam.mobile = self.loginModel.data.account.mobile;
    self.meetingParam.nickname = self.loginModel.data.account.nickname;
    self.meetingParam.extendInfo = @"测试扩展信息";
    
    /// 会控设置
    self.meetingParam.isHardwarede = self.isHardware;
    self.meetingParam.isAdaptation = !self.isDelayAdaptation;
    self.meetingParam.isCodeRate = !self.isBitRateAdaptation;
    self.meetingParam.isOpenAudio = !self.isThisAudio;
    self.meetingParam.isOpenVideo = !self.isThisVideo;
    self.meetingParam.isOpenDebug = YES;
    self.meetingParam.isOpenSpeaker = self.isOpenSpeaker;
    self.meetingParam.isOpenTCP = YES;
    
    /// 采样率等设置(小于0的设置时SDK内部采用默认参数)
    self.meetingParam.AGC = [self.agcText intValue];
    self.meetingParam.AEC = [self.aecText intValue];
    self.meetingParam.Sampe = [self.sampeText intValue];
    self.meetingParam.fps = [self.fpsText intValue];
    NSArray *vbirateArray = [self.vbirateText componentsSeparatedByString:@"*"];
    if (vbirateArray.count == 2) {
        self.meetingParam.vbirate = [[vbirateArray firstObject] intValue] * [[vbirateArray lastObject] intValue];
    }
    
    /// 设置音频编码模式
    self.meetingParam.audioEncode = self.isAudioEncodeAac ? VCSAudioEncodeStateAac : VCSAudioEncodeStateOpus;
    
    /// 远程调试地址
    self.meetingParam.debugHost = self.debugAddrText;
    
    /// 设置本地采集参数
    self.meetingParam.isHorizontalScreen = NO;
//    self.meetingParam.outWidth = 1080;
//    self.meetingParam.outHeight = 1920;
    self.meetingParam.outWidth = 720;
    self.meetingParam.outHeight = 1280;
//    self.meetingParam.outWidth = 480;
//    self.meetingParam.outHeight = 640;
//    self.meetingParam.outWidth = 480;
//    self.meetingParam.outHeight = 848;
//    self.meetingParam.outWidth = 180;
//    self.meetingParam.outHeight = 320;
    self.meetingParam.deviceOrientation = UIDeviceOrientationPortrait;
    self.meetingParam.centerInside = YES;
    self.meetingParam.isMirror = YES;
    self.meetingParam.onAudioCycle = 300;
    /// 设置设备标识码
    self.meetingParam.deviceId = DeviceUUID;
    
    /// 构建进入房间请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.roomNumberText forKey:@"room_no"];
    [params setValue:DeviceUUID forKey:@"device_id"];
    
    [[FWNetworkBridge sharedManager] POST:FWUserEnterRoomInfofacePart params:params className:@"FWEnterRoomModel" result:^(BOOL isSuccess, id _Nullable result, NSString * _Nullable errorMsg) {
        self.loading = NO;
        if (isSuccess && result) {
            self.promptText = @"进入会议成功";
            self.enterRoomModel = (FWEnterRoomModel *)result;
            /// 房间信息设置
            self.meetingParam.session = self.enterRoomModel.data.session;
            self.meetingParam.sdkNo = (int)self.enterRoomModel.data.room.sdk_no;
            self.meetingParam.roomId = self.enterRoomModel.data.room.id;
            self.meetingParam.streamHost = self.enterRoomModel.data.stream_host;
            self.meetingParam.streamPort = (int)self.enterRoomModel.data.stream_port;
            self.meetingParam.meetingHost = self.enterRoomModel.data.meeting_host;
            self.meetingParam.meetingPort = (int)self.enterRoomModel.data.meeting_port;
            self.meetingParam.serverId = self.enterRoomModel.data.meeting_server_id;
            
            [self.enterRoomSubject sendNext:self.meetingParam];
        } else {
            self.promptText = errorMsg;
        }
    }];
}

@end
