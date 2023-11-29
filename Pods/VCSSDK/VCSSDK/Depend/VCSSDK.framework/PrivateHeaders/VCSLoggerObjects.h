//
//  VCSLoggerObjects.h
//  VCSSDK
//
//  Created by SailorGa on 2022/9/29.
//

#import <Foundation/Foundation.h>
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 日志等级
/**
 日志等级

 - VCSLoggerLevelTrace: 细粒度调试
 - VCSLoggerLevelDebug: 调试
 - VCSLoggerLevelInfo: 信息
 - VCSLoggerLevelWarn: 警告
 - VCSLoggerLevelError: 错误
 - VCSLoggerLevelFatal: 致命
*/
typedef NS_ENUM(NSInteger, VCSLoggerLevel) {
    
    VCSLoggerLevelTrace = 1,
    VCSLoggerLevelDebug = 5,
    VCSLoggerLevelInfo = 9,
    VCSLoggerLevelWarn = 13,
    VCSLoggerLevelError = 17,
    VCSLoggerLevelFatal = 21,
};

@class VCSLoggerItemModel;
@class VCSLoggerParam;

@class VCSMetricItemModel;
@class VCSMetricNetworkModel;
@class VCSMetricDeviceModel;
@class VCSMetricAudioModel;
@class VCSMetricVideoModel;

#pragma mark - 行为日志上报对象
@interface VCSLoggerModel : NSObject

/// 设备标识
@property (nonatomic, copy) NSString *device_id;
/// 设备类型，默认 TerminalType_TerminalIos
@property (nonatomic, assign) NSInteger device_type;

/// 日志列表
@property (nonatomic, strong) NSMutableArray <VCSLoggerItemModel *> *logs;

@end

#pragma mark - 行为日志对象
@interface VCSLoggerItemModel : NSObject

/// 日志时间戳
@property (nonatomic, assign) NSInteger time;
/// 日志等级，默认 VCSLoggerLevelInfo
@property (nonatomic, assign) VCSLoggerLevel serverity;
/// 日志类型
@property (nonatomic, copy) NSString *type;

/// 用户标识
@property (nonatomic, copy, nullable) NSString *uid;
/// 用户会议昵称(入会必传)
@property (nonatomic, copy, nullable) NSString *uname;

/// 模块名称
@property (nonatomic, copy, nullable) NSString *mname;
/// 模块标识
@property (nonatomic, copy, nullable) NSString *mid;

/// 会议记录标识(入会必传)
@property (nonatomic, copy, nullable) NSString *conf_log_id;
/// 参会记录标识(入会必传)
@property (nonatomic, copy, nullable) NSString *trace_id;

/// 日志内容
@property (nonatomic, assign) id body;

/// 创建行为日志对象
/// - Parameters:
///   - serverity: 日志等级
///   - type: 日志类型
///   - mname: 模块名称
///   - mid: 模块标识
///   - body: 日志内容
- (instancetype)initWithServerity:(VCSLoggerLevel)serverity type:(NSString *)type mname:(nullable NSString *)mname mid:(nullable NSString *)mid body:(id)body;

@end

#pragma mark - 实时日志上报对象
@interface VCSMetricModel : NSObject

/// 设备标识
@property (nonatomic, copy) NSString *device_id;
/// 设备类型，默认 TerminalType_TerminalIos
@property (nonatomic, assign) NSInteger device_type;

/// 日志列表
@property (nonatomic, strong) NSMutableArray <VCSMetricItemModel *> *metrics;

@end

#pragma mark - 实时日志对象
@interface VCSMetricItemModel : NSObject

/// 日志时间戳
@property (nonatomic, assign) NSInteger time;

/// 用户标识
@property (nonatomic, copy, nullable) NSString *uid;
/// 房间号码
@property (nonatomic, copy, nullable) NSString *room_no;
/// 会议记录标识
@property (nonatomic, copy, nullable) NSString *conf_log_id;
/// 参会记录标识
@property (nonatomic, copy, nullable) NSString *trace_id;

/// 网络信息
@property (nonatomic, strong, nullable) VCSMetricNetworkModel *network;
/// 设备信息采样
@property (nonatomic, strong, nullable) VCSMetricDeviceModel *device;

/// 本地音频信息
@property (nonatomic, strong, nullable) VCSMetricAudioModel *local_audio;
/// 本地视频信息
@property (nonatomic, strong, nullable) NSArray <VCSMetricVideoModel *> *local_videos;
/// 本地共享信息
@property (nonatomic, strong, nullable) VCSMetricVideoModel *local_share;

/// 远程音频信息
@property (nonatomic, strong, nullable) NSArray <VCSMetricAudioModel *> *remote_audios;
/// 远程视频信息
@property (nonatomic, strong, nullable) NSArray <VCSMetricVideoModel *> *remote_videos;
/// 远程共享信息
@property (nonatomic, strong, nullable) NSArray <VCSMetricVideoModel *> *remote_shares;

/// 创建实时日志对象
/// - Parameters:
///   - userId: 用户标识
///   - roomNo: 房间号码
///   - networkModel: 流媒体网络信息
///   - localAudio: 本地音频信息
///   - localVideos: 本地视频信息列表
///   - localShare: 本地共享信息
///   - remoteAudios: 远程音频信息列表
///   - remoteVideos: 远程视频信息列表
///   - remoteShares: 远程共享信息列表
- (instancetype)initWithUserId:(nullable NSString *)userId roomNo:(nullable NSString *)roomNo networkModel:(nullable VCSMetricNetworkModel *)networkModel localAudio:(nullable VCSMetricAudioModel *)localAudio localVideos:(nullable NSArray <VCSMetricVideoModel *> *)localVideos localShare:(nullable VCSMetricVideoModel *)localShare remoteAudios:(nullable NSArray <VCSMetricAudioModel *> *)remoteAudios remoteVideos:(nullable NSArray <VCSMetricVideoModel *> *)remoteVideos remoteShares:(nullable NSArray <VCSMetricVideoModel *> *)remoteShares;

@end

#pragma mark - 实时日志网络信息对象
@interface VCSMetricNetworkModel : NSObject

/// 上行码率
@property (nonatomic, assign) CGFloat bitrate_up;
/// 下行码率
@property (nonatomic, assign) CGFloat bitrate_down;
/// 上行丢包率(补偿后)
@property (nonatomic, assign) CGFloat lossrate_up;
/// 下行丢包率(补偿后)
@property (nonatomic, assign) CGFloat lossrate_down;
/// 上行网络延时
@property (nonatomic, assign) CGFloat delay;

@end

#pragma mark - 实时日志设备信息采样对象
@interface VCSMetricDeviceModel : NSObject

/// 系统占用CPU百分比
@property (nonatomic, assign) CGFloat cpu_system;
/// 应用占用CPU百分比
@property (nonatomic, assign) CGFloat cpu_app;

/// 系统占用内存百分比
@property (nonatomic, assign) CGFloat mem_system;
/// 应用占用内存百分比
@property (nonatomic, assign) CGFloat mem_app;

/// 系统占用内存大小
@property (nonatomic, assign) CGFloat mem_system_val;
/// 应用占用内存大小
@property (nonatomic, assign) CGFloat mem_app_val;

/// 获取当前资源占用
+ (instancetype)defaultConfig;

@end

#pragma mark - 实时日志音频对象
@interface VCSMetricAudioModel : NSObject

/// 用户标识
@property (nonatomic, copy, nullable) NSString *uid;
/// 音频码率
@property (nonatomic, assign) CGFloat bitrate;
/// 音频分贝值
@property (nonatomic, assign) CGFloat db;
/// 编码格式
@property (nonatomic, copy, nullable) NSString *codec;
/// 内部字段(流媒体标识)
@property (nonatomic, assign, readonly) NSInteger linkId;

/// 创建音频日志对象
/// - Parameters:
///   - userId: 用户标识
///   - linkId: 流媒体标识
///   - bitrate: 音频码率
///   - db: 音频分贝值
///   - codec: 编码格式
- (instancetype)initWithUserId:(nullable NSString *)userId linkId:(NSInteger)linkId bitrate:(CGFloat)bitrate db:(CGFloat)db codec:(nullable NSString *)codec;

@end

#pragma mark - 实时日志视频对象
@interface VCSMetricVideoModel : NSObject

/// 用户标识
@property (nonatomic, copy, nullable) NSString *uid;
/// 视频码率
@property (nonatomic, assign) CGFloat bitrate;
/// 视频分辨率
@property (nonatomic, assign) CGFloat height;
/// 视频分辨率
@property (nonatomic, assign) CGFloat width;
/// 视频帧率
@property (nonatomic, assign) CGFloat frame_rate;

/// 视频轨道
@property (nonatomic, assign) int track;
/// 编码格式
@property (nonatomic, copy, nullable) NSString *codec;

/// 创建视频日志对象
/// - Parameters:
///   - userId: 用户标识
///   - bitrate: 视频码率
///   - height: 视频分辨率
///   - width: 视频分辨率
///   - framerate: 视频帧率
///   - track: 视频轨道
///   - codec: 编码格式
- (instancetype)initWithUserId:(nullable NSString *)userId bitrate:(CGFloat)bitrate height:(CGFloat)height width:(CGFloat)width framerate:(CGFloat)framerate track:(int)track codec:(nullable NSString *)codec;

@end

NS_ASSUME_NONNULL_END
