//
//  VCSAudioManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import "VCSAudioRecorderManager.h"
#import "VCSAudioPlayerManager.h"
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSAudioManager : NSObject

#pragma mark 录音对象
/// 录音对象
@property (nonatomic, strong) VCSAudioRecorderManager *audioRecorder;

#pragma mark 播放对象
/// 播放对象
@property (nonatomic, strong) VCSAudioPlayerManager *audioPlayer;

#pragma mark 单例模式获取录音服务实例
/// 单例模式获取录音服务实例
+ (VCSAudioManager *)sharedManager;

#pragma mark 获取录音服务版本号
/// 获取录音服务版本号
- (NSString *)version;

#pragma mark 获取录音服务版本信息
/// 获取录音服务版本信息
- (NSString *)getVersionInfo;

#pragma mark 销毁释放录音服务资源
/// 销毁释放录音服务资源
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
