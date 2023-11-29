//
//  VCSMeetingParam.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <Foundation/Foundation.h>
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSMeetingParam : NSObject

#pragma mark - 当前登录用户信息(可由登录获取)(必填项)
/* ****************** ⬇️ 当前登录用户信息(可由登录获取)(必填项) ⬇️ ****************** */
#pragma mark 当前登录SDK编号
@property (nonatomic, assign) int currentSdkNo;
#pragma mark 用户ID
@property (nonatomic, copy) NSString *accountId;
#pragma mark 用户名
@property (nonatomic, copy) NSString *name;
#pragma mark 手机号码
@property (nonatomic, copy) NSString *mobile;
#pragma mark 用户昵称
@property (nonatomic, copy) NSString *nickname;
#pragma mark 用户头像
@property (nonatomic, copy) NSString *portrait;
#pragma mark 头像相对地址
@property (nonatomic, copy) NSString *relativePortrait;
#pragma mark 绑定数据
@property (nonatomic, copy) NSString *tag;
#pragma mark 扩展字段
@property (nonatomic, copy) NSString *extendInfo;
/* ****************** ⬆️ 当前登录用户信息(可由登录获取)(必填项) ⬆️ ****************** */


#pragma mark - 入会房间信息(可由创建会议/连线获取)(必填项)
/* ****************** ⬇️ 入会房间信息(可由创建会议/连线获取)(必填项) ⬇️ ****************** */
#pragma mark 进入房间凭证
@property (nonatomic, copy) NSString *session;
#pragma mark 进入房间SDK编号
@property (nonatomic, assign) int sdkNo;
#pragma mark 进入房间ID
@property (nonatomic, copy) NSString *roomId;
#pragma mark 房间是否加密
@property (nonatomic, assign) BOOL isEncrypt;
/* ****************** ⬆️ 入会房间信息(可由创建会议/连线获取)(必填项) ⬆️ ****************** */


#pragma mark - 流媒体服务和互动服务地址端口(可由创建会议/连线获取)(必填项)
/* ******** ⬇️ 流媒体服务和互动服务地址端口(可由创建会议/连线获取)(必填项) ⬇️ ********* */
#pragma mark 流媒体服务地址
@property (nonatomic, copy) NSString *streamHost;
#pragma mark 流媒体服务端口
@property (nonatomic, assign) int streamPort;
#pragma mark 互动服务器地址
@property (nonatomic, copy) NSString *meetingHost;
#pragma mark 互动服务器端口
@property (nonatomic, assign) int meetingPort;
#pragma mark 会议服务ID
@property (nonatomic, copy) NSString *serverId;
/* ******** ⬆️ 流媒体服务和互动服务地址端口(可由创建会议/连线获取)(必填项) ⬆️ ******** */


#pragma mark - AGC AEC Sampe 编码参数设置(选填项)
/* ****************** ⬇️ AGC AEC Sampe 编码参数设置(选填项) ⬇️ ****************** */
#pragma mark 设置AGC 默认16000
@property (nonatomic, assign) int AGC;
#pragma mark 设置AEC 默认12
@property (nonatomic, assign) int AEC;
#pragma mark 设置音频采样率 默认48000
@property (nonatomic, assign) int Sampe;
#pragma mark 设置帧率 默认25
@property (nonatomic, assign) int fps;
#pragma mark 设置码率 默认900*1024
@property (nonatomic, assign) int vbirate;
#pragma mark 设置音频编码模式 默认VCSAudioEncodeStateAac
@property (nonatomic, assign) VCSAudioEncodeState audioEncode;

#pragma mark 设置是否横屏
@property (nonatomic, assign) BOOL isHorizontalScreen;

/// 输出分辨率宽必须是16的倍数 高必须是2的倍数 否则容易出现绿边等问题(已做了兼容)
/// 1080P---1920x1080 (2000*1024)
/// 720P---1280x720 (1500*1024)
/// 480P---640x480 (900*1024)
/// 180P---320x180 (500*1024)
#pragma mark 设置输出分辨率宽 默认480
@property (nonatomic, assign) int outWidth;
#pragma mark 设置输出分辨率高 默认640
@property (nonatomic, assign) int outHeight;

#pragma mark - 编码小流的相关参数设置(选填项)
#pragma mark 子码流帧率 默认15
@property (nonatomic, assign) int fps_sub;
#pragma mark 子码流码率 默认128*1024
@property (nonatomic, assign) int vbirate_sub;
#pragma mark 子码流分辨率 默认180
@property (nonatomic, assign) int height_sub;

#pragma mark 设置预览方向
/// 设置预览方向默认 UIDeviceOrientationLandscapeLeft
@property(nonatomic, assign) UIDeviceOrientation deviceOrientation;
#pragma mark 设置预览是否开启镜像
/// 设置预览是否开启镜像
@property (nonatomic, assign) BOOL isMirror;
#pragma mark 设置是否自动加适应加黑边
/// 是否自动加适应加黑边，在竖屏采集用可以设置加黑边 默认不自动适应加黑边
@property (nonatomic, assign) BOOL centerInside;

#pragma mark 获取云端音频数据信息周期(语音激励数据获取周期)
/// 获取云端音频数据信息周期(语音激励数据获取周期)
/// 单位为毫秒 默认为500毫秒
@property (nonatomic, assign) float onAudioCycle;

#pragma mark 接收自适应延迟补充区间
/// 补充区间下限，默认 500
@property (nonatomic, assign) int lowerLimit;
/// 补充区间上限，默认 1200
@property (nonatomic, assign) int upperLimit;

#pragma mark 保存音频流数据相关
/// 保存本地采集音频流，默认 NO
@property (nonatomic, assign) BOOL enableSaveAudioCapture;
/// 保存远程接收音频流，默认 NO
@property (nonatomic, assign) BOOL enableSaveAudioReceive;

/* ****************** ⬆️ AGC AEC sampe 编码参数设置(选填项) ⬆️ ****************** */


/* ****************** ⬇️ 远程调试地址 ⬇️ ****************** */
#pragma mark 远程调试地址
@property (nonatomic, copy) NSString *debugHost;
/* ****************** ⬆️ 远程调试地址 ⬆️ ****************** */


#pragma mark - 会控属性设置
/* ****************** ⬇️ 会控属性设置 ⬇️ ****************** */
#pragma mark 硬件解码 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isHardwarede;
#pragma mark 网络自适应延迟 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isAdaptation;
#pragma mark 码率自适应 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isCodeRate;
#pragma mark 音频状态 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isOpenAudio;
#pragma mark 视频状态 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isOpenVideo;
#pragma mark 扬声器状态 YES开启 NO关闭，默认 YES
@property (nonatomic, assign) BOOL isOpenSpeaker;
#pragma mark Debug模式状态 YES开启 NO关闭，默认 NO
@property (nonatomic, assign) BOOL isOpenDebug;
/* ****************** ⬆️ 会控属性设置 ⬆️ ****************** */


/* ****************** ⬇️ 会控服务协议选择 ⬇️ ****************** */
/// 会控服务是否使用TCP协议，默认 YES
@property (nonatomic, assign) BOOL isOpenTCP;
/* ****************** ⬆️ 会控服务协议选择 ⬆️ ****************** */

/// 设备标识
@property (nonatomic, strong) NSString *deviceId;

@end

NS_ASSUME_NONNULL_END
