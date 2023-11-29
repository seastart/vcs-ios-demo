//
//  VCSAudioPlayerManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import "VCSAudioManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSAudioPlayerManager : NSObject

#pragma mark 录音服务相关代理
/// 录音服务相关代理
@property (nonatomic, weak) id <VCSAudioManagerProtocol> delegate;

#pragma mark 开始播放
/// 开始播放
/// @param filePath 文件路径
/// @param complete 结果回调
- (void)playerStartWithFilePath:(NSString *)filePath complete:(void (^)(BOOL isFailed))complete;

#pragma mark 暂停播放
/// 暂停播放
- (void)playerPause;

#pragma mark 释放播放资源
/// 释放播放资源
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
