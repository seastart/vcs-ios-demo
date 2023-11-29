//
//  VCSMeetingManager.h
//  VCSSDK
//
//  Created by SailorGa on 2020/4/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AnyliveSDK/AnyliveSDK.h>
#import <hkScreenShared/hkScreenShared.h>
#import "VCSMeetingParam.h"
#import "VCSStreamMediaManager.h"
#import "VCSChatRoomManager.h"
#import "VCSCameraGatherManager.h"
#import "VCSScreenRecordingServerManager.h"
#import "VCSScreenRecordingClientManager.h"
#import "Models.pbobjc.h"
#import "RoomServer.pbobjc.h"
#import "VCSCommons.h"
#import "RTCModel.h"
#import "VCSMeetingManagerProtocol.h"
#import "VCSMeetingMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSMeetingManager;

/// 释放完成回调
typedef void (^VCSMeetingManagerDestroyBlock)(void);

@interface VCSMeetingManager : NSObject

#pragma mark 视频会议相关代理
@property (nonatomic, weak) id <VCSMeetingManagerProtocol> delegate;
#pragma mark 视频会议本地采集相关代理
@property (nonatomic, weak) id <VCSMeetingManagerCameraProtocol> cameraDelegate;
#pragma mark 会控参数
@property (nonatomic, strong) VCSMeetingParam *meetingParam;
#pragma mark 房间信息
@property (nonatomic, strong) Room *room;
#pragma mark 当前用户信息
@property (nonatomic, strong, readonly) Account *account;
#pragma mark 当前参会人列表(streamId为Key, VCSMeetingMemberModel为Value)
@property (nonatomic, strong) NSMutableDictionary<NSString *, VCSMeetingMemberModel *> *meetingMembers;
#pragma mark 当前接收参会人音视频轨道列表(streamId为Key, 轨道track为Value)
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *membersStreamTrackStateDic;
#pragma mark 当前接收参会人Picker列表(streamId为Key, Picker类型为Value)
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *membersStreamPickerStateDic;
#pragma mark 临时记录当前音频发送状态
@property (nonatomic, assign) DeviceState tempState;
#pragma mark 标记当前接收所有人视频状态(YES-接收 NO-屏蔽)
@property (nonatomic, assign) BOOL acceptvVideoState;
#pragma mark 标记当前接收所有人音频状态(YES-接收 NO-屏蔽)
@property (nonatomic, assign) BOOL acceptvAudioState;
#pragma mark 标记是否是NoPickAudio模式(YES-是 NO-否)
@property (nonatomic, assign) BOOL isNoPickAudio;
#pragma mark 标记当前的音频路由
@property (nonatomic, assign) VCSOutputAudioPortState audioRouterState;
#pragma mark 标记进入房间失败
@property (nonatomic, assign) BOOL isEnterFailed;
#pragma mark 标记SDK是否在释放
@property (nonatomic, assign) BOOL isDestroy;
#pragma mark 标记本地采集是否开启
@property (nonatomic, assign) BOOL isCameraCapture;
#pragma mark 标识当前是否在房间内
@property (nonatomic, assign) BOOL enterRoom;
#pragma mark 标记本地共享状态
@property (nonatomic, assign) BOOL isLocalShared;

#pragma mark 标记是否开启语音模式(YES-开启 NO-关闭)
/// 标记是否开启语音模式(YES-开启 NO-关闭)
@property (nonatomic, assign, readonly) BOOL isAudioMode;

#pragma mark (音频转发包 视频转发包 数据转发包 SDP转发包)
#pragma mark - -------- 视频会议基础接口 ---------
#pragma mark 单例模式初始化流媒体服务类
+ (VCSMeetingManager *)sharedManager;

#pragma mark 初始化会议SDK(YES-连接成功，NO-连接失败)
/// 初始化会议SDK(YES-连接成功，NO-连接失败)
/// @param meetingParam 会控参数
/// @param isNoPickAudio 是否开启NoPickAudio模式(视频默认选择4方，音频选择所有发言者)
/// @param delegate 代理委托
- (BOOL)initMediaSessionWithMeetingParam:(VCSMeetingParam *)meetingParam isNoPickAudio:(BOOL)isNoPickAudio delegate:(id <VCSMeetingManagerProtocol>)delegate;

#pragma mark 重新加入会议
/// 重新加入会议(网络异常后重新入会调用)
/// @param meetingHost 互动服务器地址
/// @param meetingPort 互动服务器端口
/// @param streamHost 流媒体服务器地址
/// @param streamPort 流媒体服务器端口
/// @param session 进入房间凭证
- (void)restartMeetingWithMeetingHost:(NSString *)meetingHost meetingPort:(int)meetingPort streamHost:(NSString *)streamHost streamPort:(int)streamPort session:(NSString *)session;

#pragma mark 获取SDK版本号
/// 获取SDK版本号
- (NSString *)version;

#pragma mark 获取SDK版本信息
/// 获取SDK版本信息
- (NSString *)getVersionInfo;

#pragma mark 开启或关闭Debug模式
/// 开启或关闭Debug模式
/// @param isOpenDebug YES开启 NO关闭
- (void)debugModelWithOpen:(BOOL)isOpenDebug;

#pragma mark 销毁释放视频会议资源
/// 销毁释放视频会议资源
/// @param initiative 是否主动退出(用户点击退出会议时需要传YES)
/// @param finishBlock 释放完成回调
- (void)destroy:(BOOL)initiative finishBlock:(VCSMeetingManagerDestroyBlock)finishBlock;


#pragma mark - -------- 视频会议屏幕录制相关接口 ---------
#pragma mark 开启录制调用端(编码模式)
/// 开启录制调用端(编码模式)
- (void)startEncoderScreenRecordingServer;

#pragma mark 开启录制调用端(非编码模式)
/// 开启录制调用端(非编码模式)
- (void)startScreenRecordingServer;

#pragma mark 关闭本次录屏服务
/// 关闭本次录屏服务
- (void)closeScreenServer;

#pragma mark 开启录制被调用端(编码模式)
/// 开启录制被调用端(编码模式)
/// @param closeBlock 被调用端关闭回调
- (void)startEncoderScreenRecordingClient:(VCSScreenClientCloseBlock)closeBlock;

#pragma mark 开启录制被调用端(非编码模式)
/// 开启录制被调用端(非编码模式)
/// @param closeBlock 被调用端关闭回调
- (void)startScreenRecordingClient:(VCSScreenClientCloseBlock)closeBlock;

#pragma mark - 发送共享屏幕帧数据
/// 发送共享屏幕帧数据
/// @param sampleBuffer 帧数据
/// @param sampleBufferType 帧数据类型
- (void)sendSampleBufferServer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType;


#pragma mark - -------- 视频会议流媒体服务相关接口 ---------
#pragma mark 设置网络延时抗抖动等级(重传档位)
/// 设置网络延时抗抖动等级(重传档位)
/// @param state 档位(默认为VCSNetworkDelayShakeStateMedium)
- (void)setNetworkDelayShakeWithState:(VCSNetworkDelayShakeState)state;

#pragma mark 开启/关闭语音模式
/// 开启/关闭语音模式
/// @param isAudioMode YES-开启 NO-关闭
- (void)enableAudioMode:(BOOL)isAudioMode;

#pragma mark 关闭/开启音频(是否发送音频)
/// 关闭/开启音频(是否发送音频)
/// @param state 设备状态
- (void)enableSendAudio:(DeviceState)state;

#pragma mark 关闭/开启视频(是否发送视频)
/// 关闭/开启视频(是否发送视频)
- (void)enableSendVideo:(DeviceState)state;

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
- (void)enableRecvVideoWithClientId:(int)otherClientId besidesId:(nullable NSString *)besidesId enabled:(BOOL)enabled;

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

#pragma mark 是否开启NoPickAudio模式
/// 是否开启NoPickAudio模式
/// 视频默认选择4方，音频选择所有发言者
/// @param isOpen YES-开启 NO-关闭
- (void)setPickAudioWithOpen:(BOOL)isOpen;

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

#pragma mark 停止发送媒体流(音频和视频)
/// 停止发送媒体流(音频和视频)
/// @param pause 1-停止发送，0-恢复发送
- (NSInteger)stopSendAudioAndVideo:(int)pause;

#pragma mark 释放会控中心停止某个与会者发言权的接收资源
/// 释放会控中心停止某个与会者发言权的接收资源
/// 当会控中心停止某个与会者(例如 20001234)的发言权，并把发言权授予另一个与会者(例如 20001235)时，由于客户端判断 20001234 用户离线的方法是三秒内收不到流，这种方式实时性不强，在这三秒内可能 SDK 资源满了，就不能接收新来的 20001235 的流了。所以会控中心在停止 20001234 发言权的同时，发送命令给其他与会者调用 kickout 方法，迅速释放 SDK 内 20001234 的接收资源。被 kickout 的用户三秒内无法再被接收，即便对方有流发送过来。
/// @param clientId 与会者ID
- (void)releaseKickoutResource:(int)clientId;

#pragma mark 设置声音播放开关
/// 设置声音播放开关
/// @param isOpen YES-打开 NO-关闭
- (void)setSpeakerSwitch:(BOOL)isOpen;

#pragma mark 切换音频输出端口
/// 切换音频输出端口
/// @param state 输出端口类型
- (void)overrideOutputAudioPort:(VCSOutputAudioPortState)state;

#pragma mark 设置关闭Camera采集推送
/// 设置关闭Camera采集推送，在非编码模式下有效
/// 非编码模式录屏下必须通过该函数来却换流推送
/// @param isClose YES-关闭 NO-开启
- (void)setCloseCameraStream:(BOOL)isClose;

#pragma mark 打印调试日志
/// 打印调试日志
/// @param printInfo 打印信息
- (void)debuggerPrint:(NSString *)printInfo;

#pragma mark 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
/// 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
- (void)closeDebugger;

#pragma mark 保存视频流数据
/// 保存视频流数据
/// @param isOpen YES-打开 NO-关闭
- (void)saveVideoStreamData:(BOOL)isOpen;

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


#pragma mark - -------- 视频会议本地采集相关接口 ---------
#pragma mark 却换屏幕方向
/// 却换屏幕方向
/// @param orientation 预览画面方向
/// @param previewSize 预览画面尺寸
/// @param isHorizontalScreen YES-横屏 NO-竖屏
- (void)changeScreenOrientation:(UIDeviceOrientation)orientation previewSize:(CGSize)previewSize isHorizontalScreen:(BOOL)isHorizontalScreen;

#pragma mark 获取本地预览播放器
/// 获取本地预览播放器
- (nullable RTYUVPlayer *)localPreview;

#pragma mark 加载采集实例
/// 加载采集实例
/// @param displayView 预览播放器
- (void)onLocalDisplayViewReady:(RTYUVPlayer *)displayView;

#pragma mark 开启摄像头预览和采集
/// 开启摄像头预览和采集
- (void)startCapture;

#pragma mark 停止摄像头预览和采集
/// 停止摄像头预览和采集
- (void)stopCapture;

#pragma mark 设置视频曝光率
/// 设置视频曝光率
/// @param value 曝光值(-8.0~8.0)
- (void)setVideoExposure:(float)value;

#pragma mark 设置镜头拉伸
/// 设置镜头拉伸
/// @param value 拉伸值(1.0~5.0)
- (void)setCameraZoomFatory:(float)value;

#pragma mark 切换摄像头(前置or后置)
/// 切换摄像头(前置or后置)
- (void)switchCamera;

#pragma mark 打开/关闭闪光灯
/// 打开/关闭闪光灯
/// @param isOpen YES-打开 NO-关闭
- (void)flashlightCamera:(BOOL)isOpen;

#pragma mark 启用自动闪光灯
/// 启用自动闪光灯
- (void)setFlashlightAuto;

#pragma mark 判断前置摄像头是否可用
/// 判断前置摄像头是否可用
- (BOOL)isFrontCameraAvailable;

#pragma mark 判断后置摄像头是否可用
/// 判断后置摄像头是否可用
- (BOOL)isBackCameraAvailable;

#pragma mark 判断设备是否有摄像头
/// 判断设备是否有摄像头
- (BOOL)isCameraAvailable;

#pragma mark 判断设备是否有多个摄像头
/// 判断设备是否有多个摄像头
- (BOOL)hasMultipleCameras;

#pragma mark 获取实际的采集大小
/// 获取实际的采集大小
- (CGSize)getRealCaptureSize;

#pragma mark 手动聚焦
/// 手动聚焦
/// @param point 标点
- (void)setFocusAtPoint:(CGPoint)point;

#pragma mark 设置画面预览方向
/// 设置画面预览方向
/// @param deviceOrientation 预览方向
- (void)setPreviewOrientation:(UIDeviceOrientation)deviceOrientation;

#pragma mark 手动修正预览界面
/// 手动修正预览界面
/// @param size 大小
- (void)revisePreviewSize:(CGSize)size;

#pragma mark 设置是否开启预览镜像
/// 设置是否开启预览镜像
/// @param isMirror 是否开启
- (void)setPreviewMirror:(BOOL)isMirror;

#pragma mark 获取当前摄像头
/// 获取当前摄像头 0-代表前置 1-代表后置
- (int)getCurrenCamera;


#pragma mark - -------- 视频会议互动消息服务相关接口 ---------
#pragma mark 更新心跳(自身状态变化时需要及时调用此方法)
- (void)renewMyAccountHeartBeat;

#pragma mark 发送退出房间消息
- (void)sendExitRoom;

#pragma mark 变更个人信息的扩展字段
/// 变更个人信息的扩展字段
/// @param extend 扩展字段内容
- (void)changeAccountExtend:(NSString *)extend;

#pragma mark 发送举手操作消息
/// 发送举手操作消息
/// @param hus 举手类型(HandUpStatus_HusNone-无，HandUpStatus_HusLiftTheBan-解除禁言请求)
- (void)sendRaiseHandWithHus:(HandUpStatus)hus;

#pragma mark 发送聊天消息
/// 发送聊天消息
/// @param message 消息内容
/// @param targetId 目标用户ID(不传代表发送给会议室全体人员)
/// @param type 消息类型(MessageType_MtPicture消息待完善)
- (void)sendTextChatWithMessage:(nullable NSString *)message targetId:(nullable NSString *)targetId type:(MessageType)type;

#pragma mark 发送主持人踢人消息
/// 发送主持人踢人消息
/// @param targetId 目标用户ID
- (void)sendKickoutWithTargetId:(nullable NSString *)targetId;

#pragma mark 发送主持人禁用/关闭/开启音频消息
/// 发送主持人禁用/开启音频消息
/// @param targetId 目标用户ID(为空时代表全局禁用)
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlAudioWithTargetId:(nullable NSString *)targetId audioState:(DeviceState)audioState DEPRECATED_MSG_ATTRIBUTE("此方法已经弃用，请迁移到sendKostCtrlMemberAudioWithTargetidsArray:audioState:接口");

#pragma mark 发送主持人禁用/关闭/开启视频消息
/// 发送主持人禁用/开启视频消息
/// @param targetId 目标用户ID(为空时代表全局禁用)
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlVideoWithTargetId:(nullable NSString *)targetId videoState:(DeviceState)videoState DEPRECATED_MSG_ATTRIBUTE("此方法已经弃用，请迁移到sendKostCtrlMemberVideoWithTargetidsArray:videoState:接口");

#pragma mark 发送主持人操作成员音频消息
/// 发送主持人操作成员音频消息
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlMemberAudioWithTargetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray audioState:(DeviceState)audioState;

#pragma mark 发送主持人操作成员视频消息
/// 发送主持人操作成员视频消息
/// @param targetidsArray 成员列表(为空时表示全局禁用)
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlMemberVideoWithTargetidsArray:(nullable NSMutableArray<NSString *> *)targetidsArray videoState:(DeviceState)videoState;

#pragma mark 发送主持人操作房间音频消息
/// 发送主持人操作房间音频消息
/// @param audioState 音频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlRoomAudioWithAudioState:(DeviceState)audioState;

#pragma mark 发送主持人操作房间视频消息
/// 发送主持人操作房间视频消息
/// @param videoState 视频状态(DeviceState_DsActive-正常，DeviceState_DsClosed-关闭，DeviceState_DsDisabled-禁用)
- (void)sendKostCtrlRoomVideoWithVideoState:(DeviceState)videoState;

#pragma mark 推送码流发生变化
/// 推送码流发生变化
/// @param operation 操作指令(Operation_OperationRemove-移除，Operation_OperationAdd-添加，Operation_OperationUpdate-更新)
/// @param stream 码流信息
- (void)changedRoomStreamWithOperation:(Operation)operation stream:(Stream *)stream;

#pragma mark 发送透传消息(自定义消息)
/// 发送透传消息(自定义消息)
/// @param targetId 目标用户
/// @param message 自定义消息
- (void)sendRoomPassthroughWithTargetId:(NSString *)targetId message:(NSString *)message;

#pragma mark 主持人变更码流
/// 主持人变更码流
/// @param targetId 目标用户
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息
- (void)hostChangedRoomStreamWithTargetId:(NSString *)targetId operation:(Operation)operation stream:(Stream *)stream;

#pragma mark 主持人处理举手
/// 主持人处理举手
/// @param targetId 目标用户
/// @param hus 举手类型(HandUpStatus_HusNone-无，HandUpStatus_HusLiftTheBan-解除禁言请求)
/// @param result 处理结果(YES-同意，NO-不同意)
- (void)hostDisposeRoomRaiseHandWithTargetId:(NSString *)targetId hus:(HandUpStatus)hus result:(BOOL)result;

#pragma mark 开始分享
/// 开始分享(包括：白板、图片、桌面)
/// @param sharingType 分享类型
/// @param sharingPicURL 分享图片时的图片地址
/// @param sharingRelativePicURL 分享图片时的图片相对地址
- (void)sendRoomStartToShareWithSharingType:(SharingType)sharingType sharingPicURL:(nullable NSString *)sharingPicURL sharingRelativePicURL:(nullable NSString *)sharingRelativePicURL;

#pragma mark 停止分享
/// 停止分享(包括：白板、图片、桌面)
- (void)sendRoomStopSharing;

#pragma mark 设置开启&关闭水印
/// 设置开启&关闭水印
/// @param openState YES-开启水印 NO-关闭水印
- (void)sendRoomWaterMarkWithOpenState:(BOOL)openState;

#pragma mark 转移房间主持人权限
/// 转移房间主持人权限
/// @param targetId 目标用户
- (void)sendRoomMoveHostWithTargetId:(NSString *)targetId;

#pragma mark 设置房间联席主持人权限
/// 设置房间联席主持人权限
/// @param targetId 目标用户
/// @param enable YES-设置 NO-回收
- (void)sendRoomUnionHostWithTargetId:(NSString *)targetId enable:(BOOL)enable;

#pragma mark 回收房间主持人权限
/// 回收房间主持人权限
/// @param targetId 目标用户
- (void)sendRoomRecoveryHostWithTargetId:(nullable NSString *)targetId;

#pragma mark 设置房间静音状态
/// 设置房间静音状态
/// @param state 静音状态
- (void)sendRoomMuteWithState:(MuteState)state;

#pragma mark 设置房间成员昵称
/// 设置房间成员昵称
/// @param targetId 目标用户ID
/// @param nickname 目标昵称
/// @param selves 是否为当前账户(YES-自己 NO-其它成员)
- (void)sendRoomMemberNicknameWithTargetId:(nullable NSString *)targetId nickname:(NSString *)nickname selves:(BOOL)selves;

#pragma mark 设置房间是否允许自行解除禁音
/// 设置房间是否允许自行解除禁音
/// @param enable YES-允许解除禁音 NO-不允许解除禁音
- (void)sendRoomRelieveStateWithEnable:(BOOL)enable;

#pragma mark 设置房间成员扩展信息
/// 设置房间成员扩展信息
/// - Parameters:
///   - targetId: 目标用户标识
///   - extendInfo: 扩展信息
///   - selves: 是否为当前账户(YES-自己 NO-其它成员)
- (void)sendRoomMemberExtendWithTargetId:(nullable NSString *)targetId extendInfo:(NSString *)extendInfo selves:(BOOL)selves;

#pragma mark - 事件命令透传处理
/// 事件命令透传处理
/// @param command 消息指令
/// @param notify 通知内容
- (void)roomListenEventWithCommand:(VCSCommandEventState)command notify:(GPBMessage *)notify;

@end

NS_ASSUME_NONNULL_END
