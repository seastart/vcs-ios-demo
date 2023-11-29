//
//  SampleHandler.m
//  VCSReplayBroadcastUpload
//
//  Created by SailorGa on 2020/6/1.
//  Copyright © 2020 SailorGa. All rights reserved.
//


#import "SampleHandler.h"

/// App Group ID
#define kAppGroup @"group.cn.seastart.vcsdemo"

@interface SampleHandler() <VCSReplayKitDelegate>

@end

@implementation SampleHandler

#pragma mark - 启动录屏
- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *, NSObject *> *)setupInfo {
    
    /// User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [[VCSReplayKit sharedInstance] broadcastStartedWithAppGroup:kAppGroup delegate:self];
}

#pragma mark - 暂停录屏
- (void)broadcastPaused {
    
    /// User has requested to pause the broadcast. Samples will stop being delivered.
}

#pragma mark - 恢复录屏
- (void)broadcastResumed {
    
    /// User has requested to resume the broadcast. Samples delivery will resume.
}

#pragma mark - 完成录屏
- (void)broadcastFinished {
    
    /// User has requested to finish the broadcast.
}

#pragma mark - 媒体数据(音视频)
/// 媒体数据(音视频)
/// - Parameters:
///   - sampleBuffer: 视频或音频帧
///   - sampleBufferType: 媒体类型
- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    /// 媒体数据(音视频)发送
    [[VCSReplayKit sharedInstance] sendSampleBuffer:sampleBuffer withType:sampleBufferType];
}

#pragma mark - ----- VCSReplayKitDelegate代理方法 -----
#pragma mark 录屏完成回调
/// 录屏完成回调
/// - Parameters:
///   - broadcast: 录屏实例
///   - reason: 录屏结束原因
- (void)broadcastFinished:(VCSReplayKit *)broadcast reason:(NSString *)reason {
    
    /// 声明描述
    NSString *describe = @"屏幕录制已结束";
    /// 构建Error信息
    NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:0 userInfo:@{NSLocalizedFailureReasonErrorKey : describe}];
    /// 完成屏幕录制
    [self finishBroadcastWithError:error];
}

@end
