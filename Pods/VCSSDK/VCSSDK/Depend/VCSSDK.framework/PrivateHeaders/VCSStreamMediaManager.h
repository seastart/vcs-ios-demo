//
//  VCSStreamMediaManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VCSNetworkConnectModel.h"
#import "VCSMeetingDesktopModel.h"
#import "VCSNetworkConfig.h"
#import "VCSNetworkModel.h"
#import "Models.pbobjc.h"
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSStreamMediaManager;

#pragma mark - 流媒体服务相关代理
@protocol VCSStreamMediaManagerDelegate <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark - 流媒体监听结果回调方法
#pragma mark 码率自适应状态(当前发送端码率变化回调)
/// 码率自适应状态(当前发送端码率变化回调)
/// @param state 当前发送端码率变化状态
- (void)roomSenderXbitrateChangeWithStreamState:(VCSXbitrateSendState)state;

#pragma mark 会议室流媒体码率自适应状态(接收网络状态回调)
/// 会议室流媒体码率自适应状态(接收网络状态回调)
/// @param linkId 链路ID(SDKNO&streamID)
/// @param lrlState 端到端链路状态
/// @param lrdState 下行链路状态
- (void)roomXbitrateChangeStateWithLinkId:(NSString *)linkId lrlState:(VCSXbitrateInceptState)lrlState lrdState:(VCSXbitrateInceptState)lrdState;

#pragma mark 会议室当前用户上传流媒体状态回调
/// 会议室当前用户上传流媒体状态回调
/// @param ptr 底层防止溢出字段
/// @param streamData 流媒体信息
/// {
///    uploadinfo =     (
///                {
///            buffer = 0; 上传缓冲包0-4正常
///            delay = 0; 上传延迟时间
///            overflow = 0; 上传缓冲包0-4正常
///            speed = 0kps; 上传视频速率
///            audio_speed: 0kps; 上传音频速率
///            status = "-2"; -1上传出错 >=0正常
///            loss_r = "0.00"; 当前上传丢包率
///            loss_c  = "0.00"; 经过补偿的最终上传丢包率
///        }
///    );
/// }
- (void)roomCurrentStreamStatusWithPtr:(NSString *)ptr streamData:(NSDictionary *)streamData;

#pragma mark 会议室其它与会人员上传流媒体状态回调
/// 会议室其它与会人员上传流媒体状态回调
/// @param ptr 底层防止溢出字段
/// @param streamData 流媒体信息
/// {
///     "recvinfo": [
///          {
///              "linkid": 12340001,  对方sdkno
///              "recv": 4127，接收包信息
///              "comp": 13,  补偿 高 网络不稳定
///              "losf": 0,   丢失包信息  高 就是网络差
///              "lrl": 6.8,  短时端到端丢包率（对方手机到你手机）
///              "lrd": 8.9,   短时下行丢包率（服务器到你）
///              "audio": 600,   接收音频包信息
///              "audio_speed": -1,   音频速率
///              "total_speed": -1,    视频速率
///          }
///      ]
///  }
- (void)roomParticipantStreamStatusWithPtr:(NSString *)ptr streamData:(NSDictionary *)streamData;

#pragma mark 会议室视频进入和退出流媒体输出信息回调
/// 会议室视频进入和退出流媒体输出信息回调
/// @param lparam 宽/高
/// @param wparam 宽/高
/// @param ptr 底层防止溢出字段
- (void)roomStreamDataWithLparam:(int)lparam wparam:(int)wparam ptr:(NSString *)ptr;

#pragma mark 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// 会议室参会人流媒体数据回调(可根据不同linkId显示/处理窗口)
/// @param linkId 视频链路ID
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param lable 视频角度
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)roomParticipantCameraDataWithLinkId:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;

#pragma mark 当前服务器是否允许本人发言回调
/// 当前服务器是否允许本人发言回调
/// @param state 是否允许发言(YES-允许你发言 NO-不允许你发言)
- (void)roomServiceSpeechWithState:(BOOL)state;

#pragma mark 当前讲话人员音频数据信息回调
/// 当前讲话人员音频数据信息回调
/// @param audioArray 讲话人员音频数据列表
/// {
///    streamId = 20000016; 链接ID(即：sdkno)
///    power = 6766; 功率
///    db = "-99"; 分贝值
/// }
- (void)roomAudioSpeakingStatusWithAudioArray:(NSMutableArray *)audioArray;

#pragma mark 音频输出通道改变回调
/// 音频输出通道改变回调
/// @param state 音频输出端口类型
/// @param deviceName 音频输出设置名称
- (void)roomAudioOutputPortChangeWithState:(VCSOutputAudioPortState)state deviceName:(NSString *)deviceName;

#pragma mark 当前应用CPU占用率内存使用情况回调
/// 当前应用CPU占用率内存使用情况回调
/// @param memory 内存使用
/// @param cpuUsage CPU占有率
- (void)roomAppPerformanceWithMemory:(double)memory cpuUsage:(double)cpuUsage;

#pragma mark 下行网络丢包档位变化回调
/// 下行网络丢包档位变化回调
/// @param state 下行丢包档位
- (void)roomDownstreamLevelChangeWithState:(VCSDownLevelState)state;

#pragma mark 短时平均下行丢包率回调
/// 短时平均下行丢包率回调
/// @param average 平均下行丢包率
- (void)roomDownstreamLossWithAverage:(CGFloat)average;

#pragma mark 开启网络检测
/// 开启网络检测
- (void)roomNetworkManagerDidBegined;

#pragma mark 完成网络检测
/// 完成网络检测
/// @param uploadModel 上行网络状况
/// @param downModel 下行网络状况
/// @param connectModel 网络连接状况
- (void)roomNetworkManagerDidFinshedWithUploadModel:(nullable VCSNetworkModel *)uploadModel downModel:(nullable VCSNetworkModel *)downModel connectModel:(VCSNetworkConnectModel *)connectModel;

@end

/// 释放完成回调
typedef void (^VCSStreamMediaManagerDestroyBlock)(void);

@interface VCSStreamMediaManager : NSObject

#pragma mark 流媒体服务相关代理
@property (nonatomic, weak) id <VCSStreamMediaManagerDelegate> delegate;
#pragma mark 流媒体连接Delay次数
/// @property (nonatomic, assign) NSInteger connectDelayNumber;
#pragma mark 流媒体服务连接状态
@property (nonatomic, assign) BOOL isStaticConnect;
#pragma mark 是否在共享屏幕
@property (nonatomic, assign) BOOL isScreenShare;

#pragma mark 网络状态变更
/// 网络状态变更
/// @param status 网络状态
- (void)networkReachabilityChange:(VCSNetworkReachabilityStatus)status;


#pragma mark - -------- 流媒体服务基础接口 ---------
#pragma mark 单例模式初始化流媒体服务实例
/// 单例模式初始化流媒体服务实例
+ (VCSStreamMediaManager *)sharedManager;

#pragma mark 初始化流媒体服务
/// 初始化流媒体服务
- (void)initStreamMedia;

#pragma mark 重新加入会议
/// 重新加入会议(网络异常后重新入会调用)
- (void)restartMeeting;

#pragma mark 获取流媒体SDK版本
/// 获取流媒体SDK版本
- (NSString *)getVersion;

#pragma mark 释放流媒体服务资源
/// 释放流媒体服务资源
/// @param finishBlock 释放完成回调
- (void)destroy:(VCSStreamMediaManagerDestroyBlock)finishBlock;


#pragma mark - -------- 流媒体变换接口 --------
#pragma mark 开始推流
/// 开始推流
/// @param sampleBuffer 采集器缓冲区
/// @param stamp 采样率
/// @param isFront 是否前置摄像头采集
/// @param viewChange View是否改变
- (void)startStreamingWithPushSampleBuffer:(CVPixelBufferRef)sampleBuffer stamp:(CMTime)stamp isFront:(BOOL)isFront viewChange:(int)viewChange;

#pragma mark 重置编码器
/// 重置编码器
- (void)resetStreamEncoder;

#pragma mark 设置网络延时抗抖动等级(重传档位)
/// 设置网络延时抗抖动等级(重传档位)
/// @param state 档位(默认为VCSNetworkDelayShakeStateMedium)
- (void)setNetworkDelayShakeWithState:(VCSNetworkDelayShakeState)state;

#pragma mark 关闭/开启音频(是否发送音频)
/// 关闭/开启音频(是否发送音频)
/// @param state 设备状态
- (NSInteger)enableSendAudio:(DeviceState)state;

#pragma mark 关闭/开启视频(是否发送视频)
/// 关闭/开启视频(是否发送视频)
/// @param state 设备状态
- (NSInteger)enableSendVideo:(DeviceState)state;

#pragma mark 设置自己是否接收对方音频
/// 设置自己是否接收对方音频
/// @param otherClientId 目标UID(传0代表所有与会人员)
/// @param enabled  Yes-接收  No-不接收
- (void)enableRecvAudioWithClientId:(int)otherClientId enabled:(BOOL)enabled;

#pragma mark 设置自己是否接收对方视频
/// 设置自己是否接收对方视频
/// @param otherClientId  目标UID(传0代表所有与会人员)
/// @param besidesId  除此SDKNO以外的用户(NoPickAudio模式使用)
/// @param enabled  Yes-接收  No-不接收
- (void)enableRecvVideoWithClientId:(int)otherClientId besidesId:(NSString *)besidesId enabled:(BOOL)enabled;

#pragma mark 获取当前设备是否支持硬件解码(0-不支持, 1-支持)
- (NSInteger)getHardwareSupport;

#pragma mark 获取当前解码类型(-1-未就绪, 0-软解, 1-硬件解码)
- (NSInteger)getCurrentDecoder;

#pragma mark 设置是否使用双码流
/// 设置是否使用双码流
/// @param isUse YES-使用双码流 NO-使用单码流
- (void)setMultiStream:(BOOL)isUse;

#pragma mark 设置是否关闭高清码流
/// 设置是否关闭高码流
/// @param isClose YES-使用高码流 NO-不使用高码流
- (void)setCloseHighStream:(BOOL)isClose;

#pragma mark 不接听音频语音开关
/// 不接听音频语音开关
/// 人数多的会议，视频选择 4方，音频选择所有发言者
/// @param state 1-开启 0-关闭
- (void)setPickAudioWithOpen:(int)state;

#pragma mark 语音激励开关
/// 语音激励开关
/// @param isOpen YES-开启 NO-关闭
- (void)setVoiceEncourage:(BOOL)isOpen;

#pragma mark 设置接收与会者音视频轨道
/// 设置接收与会者音视频轨道
/// @param clientId 所有与会者或与会者ID
/// @param mark 1-选择转发0视频轨, 2-选择转发1视频轨, 5=选择转发0和2视频轨
/// @param isSync 是否采用同步切换轨道
/// 同步切换轨道(如该轨道没有流会一直等待即：无论有无数据流都将切换成功)
/// 异步切换轨道(如该轨道没有流会默认切换失败，服务自动丢弃该消息)
- (void)setStreamTrackWithClientId:(int)clientId mark:(int)mark isSync:(BOOL)isSync;

#pragma mark 设置音频优先
/// 设置音频优先
/// @param clientId 会者ID(码流ID)
/// @param enable YES-开启 NO-关闭
/// 开启音频优先策略缓存长度将变为1000毫秒
- (void)setAudioPriorityWithClientId:(int)clientId enable:(BOOL)enable;

#pragma mark 设置默认轨道
/// 设置默认轨道
/// @param track 轨道
- (NSInteger)setDefaultTrack:(int)track;

#pragma mark 停止发送音频和视频
/// 停止发送音频和视频
/// @param pause 1-停止发送，0-恢复发送
- (NSInteger)stopSendAudioAndVideo:(int)pause;

#pragma mark 释放会控中心停止某个与会者发言权的接收资源
/// 释放会控中心停止某个与会者发言权的接收资源
/// 当会控中心停止某个与会者(例如 20001234)的发言权，并把发言权授予另一个与会者(例如 20001235)时，由于客户端判断 20001234 用户离线的方法是三秒内收不到流，这种方式实时性不强，在这三秒内可能 SDK 资源满了，就不能接收新来的 20001235 的流了。所以会控中心在停止 20001234 发言权的同时，发送命令给其他与会者调用 kickout 方法，迅速释放 SDK 内 20001234 的接收资源。被 kickout 的用户三秒内无法再被接收，即便对方有流发送过来。
/// @param clientId 与会者ID
- (void)releaseKickoutResource:(int)clientId;

#pragma mark 录屏数据推流(编码模式)
- (NSInteger)pushScreenEncoderStream:(NSData *)streamData stamp:(uint32_t)stamp dts:(uint32_t)dts displayAngle:(int)displayAngle;

#pragma mark 录屏数据推流(非编码模式)
- (NSInteger)pushScreenStream:(CVPixelBufferRef)sampleBuffer stamp:(CMTime)stamp rotate:(int)rotate autofixblackSide:(BOOL)fix;

#pragma mark 设置是否关闭本地采集Camera流推送，在非编码模式下有效 非编码模式录屏下必须通过该函数来却换流推送
- (void)setCloseCameraStream:(BOOL)isClose;

#pragma mark 设置扬声器开关
/// 设置扬声器开关
/// @param isOpen YES-打开 NO-关闭
- (void)setSpeakerSwitch:(BOOL)isOpen;

#pragma mark 切换音频输出端口
/// 切换音频输出端口
/// @param type 输出端口类型
- (void)overrideOutputAudioPort:(int)type;

#pragma mark 开启远程调试
/// 开启远程调试
/// @param address 地址
/// @param level 日志级别-3
- (void)openDebuggerWithAddress:(NSString *)address level:(int)level;

#pragma mark 打印调试日志
/// 打印调试日志
/// @param printInfo 打印信息
- (void)debuggerPrint:(NSString *)printInfo;

#pragma mark 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
/// 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
- (void)closeDebugger;

#pragma mark 保存视频数据
/// 保存视频数据
/// @param isOpen YES-打开 NO-关闭
- (void)saveVideoStreamData:(BOOL)isOpen;

#pragma mark 设置MCU云端系统接收轨道
/// 设置MCU云端系统接收轨道
/// @param track 轨道ID
- (void)setMcuDefaultWithTrack:(int)track;

#pragma mark 释放流媒体像素数据资源
/// 释放流媒体像素数据资源
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)destroyStreamWithyData:(void *)yData uData:(void *)uData vData:(void *)vData;

#pragma mark 开启网络监测
/// 开启网络监测
/// @param config 检测配置
- (BOOL)startNetworkDetectionWithConfig:(VCSNetworkConfig *_Nonnull)config;

#pragma mark 停止网络监测
/// 停止网络监测
- (void)stopNetworkDetection;

#pragma mark 获取当前接收的共享屏幕流信息
/// 获取当前接收的共享屏幕流信息
- (VCSMeetingDesktopModel *)getSharingDesktopInfo;

#pragma mark - -------- 语音模式流媒体设置相关接口 --------
#pragma mark 语音模式流媒体设置
/// 语音模式流媒体设置
- (void)audioModeStreamMediaSetup;

#pragma mark 非语音模式流媒体设置
/// 非语音模式流媒体设置
- (void)nonAudioModeStreamMediaSetup;

#pragma mark - -------- 触发日志相关接口 --------
#pragma mark 追加角色变化日志
/// 追加角色变化日志
/// - Parameters:
///   - originRole: 原角色
///   - newRole: 新角色
- (void)writeRoomRoleChange:(ConferenceRole)originRole newRole:(ConferenceRole)newRole;

#pragma mark 追加昵称变化日志
/// 追加昵称变化日志
/// - Parameters:
///   - originName: 原昵称
///   - newName: 新昵称
- (void)writeRoomNicknameChange:(NSString *)originName newName:(NSString *)newName;

#pragma mark 追加会控消息日志
/// 追加会控消息日志
/// - Parameters:
///   - command: 指令
///   - result: 结果
///   - type: 包类型
///   - data: 消息数据
- (void)writeMessageLogWithCommand:(Command)command result:(Result)result type:(PacketType)type data:(nullable NSString *)data;

#pragma mark 追加事件日志
/// 追加事件日志
/// - Parameters:
///   - moduleName: 模块名称
///   - logType: 日志类型
///   - params: 日志内容
- (void)addEventLogs:(NSString *)moduleName logType:(NSString *)logType params:(id)params;

#pragma mark 设置共享桌面实时信息
/// 设置共享桌面实时信息
/// - Parameters:
///   - bitrate: 码率
///   - height: 分辨率
///   - width: 分辨率
///   - framerate: 帧率
- (void)setupScreenBitrate:(int)bitrate height:(int)height width:(int)width framerate:(CGFloat)framerate;

@end

NS_ASSUME_NONNULL_END
