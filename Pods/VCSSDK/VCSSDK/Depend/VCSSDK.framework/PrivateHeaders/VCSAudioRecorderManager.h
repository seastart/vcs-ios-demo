//
//  VCSAudioRecorderManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import "VCSAudioManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSAudioRecorderManager : NSObject

#pragma mark 录音服务相关代理
/// 录音服务相关代理
@property (nonatomic, weak) id <VCSAudioManagerProtocol> delegate;

#pragma mark 是否监测录音音量(默认：NO)
/// 是否监测录音音量(默认：NO)
@property (nonatomic, assign) BOOL monitorVolume;

#pragma mark 录音限制时长(默认0，即没有时长限制)
/// 录音限制时长(默认0，即没有时长限制)
@property (nonatomic, assign) NSTimeInterval totalTime;

#pragma mark 开启录制
/// 开启录制
/// @param filePath 文件路径(默认格式为：20210324.aac)
/// @param complete 结果回调
- (void)recorderStartWithFilePath:(NSString *)filePath complete:(void (^)(BOOL isFailed))complete;

#pragma mark 停止录制
/// 停止录制
- (void)recorderStop;

#pragma mark 释放录制资源
/// 释放录制资源
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
