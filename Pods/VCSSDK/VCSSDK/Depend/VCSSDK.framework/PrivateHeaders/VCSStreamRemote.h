//
//  VCSStreamRemote.h
//  VCSSDK
//
//  Created by SailorGa on 2022/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSStreamRemote : NSObject

/// 流媒体标识
@property (nonatomic, assign, readonly) int streamId;
/// 轨道标识
@property (nonatomic, assign, readonly) int trackId;
/// 视频流宽
@property (assign, nonatomic, readonly) int width;
/// 视频流高
@property (assign, nonatomic, readonly) int height;
/// 视频帧率
@property (assign, nonatomic, readonly) int fps;
/// 最后一次帧处理时间戳(毫秒)
@property (assign, nonatomic, readonly) NSTimeInterval interval;

#pragma mark - 更新远程视频信息
/// 更新远程视频信息
/// - Parameters:
///   - linkId: 流媒体标识
///   - track: 轨道号
///   - width: 视频流宽
///   - height: 视频流高
- (void)renewStreamRemoteWithLinkId:(int)linkId track:(int)track width:(int)width height:(int)height;

@end

NS_ASSUME_NONNULL_END
