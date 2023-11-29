# 视频会议简介

[![CI Status](https://img.shields.io/travis/SailorGa/VCSSDK.svg?style=flat)](https://travis-ci.org/SailorGa/VCSSDK)
[![Version](https://img.shields.io/cocoapods/v/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![License](https://img.shields.io/cocoapods/l/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![Platform](https://img.shields.io/cocoapods/p/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)

客户端开发需要用到两部分：API和SDK。

API是以HTTP Restful形式提供的一组接口，主要负责帐号的登录、注册、充值、会议管理等操作，通过API接口获取到相应的入会凭证，然后才可以使用SDK库进入会议室，API详细接口请参见[《VCS服务端API文档》](https://www.showdoc.cc/item/index)。

SDK是客户端的原生开发包，主要负责音视频流、互动以及会控服务（如踢人、禁言等）的相关操作。

对于部分会控功能，平台在API和SDK都有提供对应的实现方式。API方式主要提供给WEB端（管理后台）开发使用，建议客户端开发使用SDK方式。

![flow](Assets/flow.png)

# VCSSDK

## SDK&DEMO

[SDK&DEMO下载](https://www.yuque.com/sailorga/vcs/aw14ns)

## 注册/登录

### API注册
使用[《VCS服务端API文档》](https://www.showdoc.cc/item/index)中注册接口[（account/register）](https://www.showdoc.cc/zhoushijie?page_id=2808182662501189) 进行帐号注册，注册成功后会立即返回token。

### 萤石云授权登录
使用萤石云帐号登录，在萤石云获取到code之后，调用[《VCS服务端API文档》](https://www.showdoc.cc/item/index)中萤石云授权登录接口[（ys/access）](https://www.showdoc.cc/zhoushijie?page_id=3146679665620573)进行登录，如果是首次登录，平台会自动创建帐号；如果之前已经授权登录过，则会使用之前创建的帐号进行登录。

### 已有帐号登录
使用已有帐号登录，调用[《VCS服务端API文档》](https://www.showdoc.cc/item/index)中登录接口[（account/login）](https://www.showdoc.cc/zhoushijie?page_id=2808310332993253)登录，登录成功后会返回token。

### 帐号类型
平台目录共有PC、iOS、Android、安卓一体机、录播主机等5种终端类型，其中主要分为两类，一类通过用户名和密码进行注册和登录，另外一类通过序列号密码进行注册和登录。

- PC、iOS、Android这三种设备类型是通过用户名和密码来进行登录。
- 安卓一体机、录播主机这两种设备是硬件设备，需要通过设备唯一序列号来进行登录。

### 连线用户/会议
用户/游客通过平台注册账号，成功登录后会返回相对应的信息，此信息包括平台id和平台鉴权信息等。通过此信息，来选择连线用户还是连线会议。
![图片1.png](https://cdn.nlark.com/yuque/0/2020/png/1227561/1588814067141-1881c8b0-702f-49ce-af62-4e71e598fcf8.png#align=left&display=inline&height=586&margin=%5Bobject%20Object%5D&name=%E5%9B%BE%E7%89%871.png&originHeight=586&originWidth=1280&size=101577&status=done&style=none&width=1280)

## 集成方式

VCSSDK提供两种集成方式：您既可以通过CocoaPods自动集成我们的SDK，也可以通过手动下载SDK, 然后添加到您的项目中。

* 编译语言：Objective-C
* 编译环境：Xcode 10及以上
* 操作系统支持：iOS 9.0及以上
* SDK暂不支持模拟器编译
* 如需请自行配置手机系统权限
* 本地视频采集请自行配置禁止锁屏(如需)
* 如需请自行适配横竖屏(SDK流媒体服务支持)
* 在 Build Settings -> Other Linker Flags 里，添加选项 -ObjC
* Enable Bitcode 配置 No
* Architectures 配置 arm64 支持
* C Language Dialect 配置 GNU99[-std=gnu99]
* C++ Language Dialect 配置 C++11[-std=c++11]
* C++ Standard Library 配置 libstdc++(LLVM C++ Standard library with C++11 support)

### 手动集成(不建议)

* 根据自己工程需要，下载对应版本的[VCSSDK](https://www.yuque.com/sailorga/vcs/aw14ns)，得到VCSSDK.framework 和 AnyliveSDK.framework，将他们导入工程。

* 添加VCSSDK依赖的系统库

```
SystemConfiguration.framework
Accelerate.framework
AvFoundation.framework
QuartzCore.framework
CoreGraphics.framework
CoreMedia.framework
CoreAudio.framework
CoreVideo.framework
OpenGLES.framework
Security.framework
CFNetwork.framework
libicucore.tbd
libc.tbd
libz.tbd
libiconv.tbd
libbz2.tbd
libc++.tbd
```

* 在需要使用VCSSDK的地方 `#import <VCSSDK/VCSSDK.h>`

* 添加VCSSDK依赖的开源库

```
pod 'AFNetworking'
pod 'Protobuf'
pod 'CocoaAsyncSocket'
```

### 自动集成(建议)

在 `Podfile` 文件中加入VCSSDK

```
pod 'VCSSDK'
```

在 `Podfile` 文件中添加VCSSDK源

```
source 'http://code.zaoing.com/meeting/freewindSpecs'
```

安装

```
pod install
```

如果无法安装SDK最新版本，运行以下命令更新本地的CocoaPods仓库列表

```
pod repo update
```

### 类库说明

| 类（协议）           | 描述           | 说明    |
| ------------------ |:--------------:| ------:|
| VCSSDK             | 对外提供头文件引用 | 提供外部所有使用文件引用 |
| VCSMeetingParam    | 入会以及会控属性 | 负责入会参数的设置和管理 |
| VCSMeetingManager  | 视频服务管理类  | 提供初始化、推流、流媒体控制、本地采集管理、互动服务等功能 |
| RTYUVPlayer        | 音视频流播放器   | 负责参会者画面(小窗口)播放 |


## API说明

> 由于视频采集时，默认横屏采集模式16:9，所以在播放是，创建的UIView模式也必须为16:9模式。（宽:高）
注意：如果宽高比例不一致，可能会导致播放视图会出现画面不全，包含黑边的模式。

### 对外提供头文件引用
```
/// 视频会议服务
#import "VCSMeetingManager.h"
```

### 入会以及会控属性
```
@interface VCSMeetingParam : NSObject

#pragma mark - 当前登录用户信息(可由登录获取)(必填项)
/* ****************** ⬇️ 当前登录用户信息(可由登录获取)(必填项) ⬇️ ****************** */
#pragma mark 当前登录SDK编号
@property (nonatomic, assign) int currentSdkNo;
#pragma mark 用户ID
@property (nonatomic, copy) NSString *accountId;
#pragma mark 用户名
@property (nonatomic, copy) NSString *name;
#pragma mark 用户昵称
@property (nonatomic, copy) NSString *nickname;
#pragma mark 用户头像
@property (nonatomic, copy) NSString *portrait;
/* ****************** ⬆️ 当前登录用户信息(可由登录获取)(必填项) ⬆️ ****************** */


#pragma mark - 入会房间信息(可由创建会议/连线获取)(必填项)
/* ****************** ⬇️ 入会房间信息(可由创建会议/连线获取)(必填项) ⬇️ ****************** */
#pragma mark 进入房间凭证
@property (nonatomic, copy) NSString *session;
#pragma mark 进入房间SDK编号
@property (nonatomic, assign) int sdkNo;
#pragma mark 进入房间ID
@property (nonatomic, copy) NSString *roomId;
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
/* ******** ⬆️ 流媒体服务和互动服务地址端口(可由创建会议/连线获取)(必填项) ⬆️ ******** */


#pragma mark - 互动服务器异常重连最大时间(默认30s)
@property (nonatomic, assign) int maxConnectDuration;


#pragma mark - AGC AEC Sampe 编码参数设置(选填项)
/* ****************** ⬇️ AGC AEC Sampe 编码参数设置(选填项) ⬇️ ****************** */
#pragma mark 设置AGC 默认16000
@property (nonatomic, assign) int AGC;
#pragma mark 设置AEC 默认12
@property (nonatomic, assign) int AEC;
#pragma mark 设置采样率 默认48000
@property (nonatomic, assign) int Sampe;

/// 输出分辨率宽必须是16的倍数 高必须是2的倍数 否则容易出现绿边等问题
#pragma mark 设置输出分辨率宽 默认848
@property (nonatomic, assign) int outWidth;
#pragma mark 设置输出分辨率高 默认480
@property (nonatomic, assign) int outHeight;

/// 支持的预览分辨率
/// AVCaptureSessionPreset352x288
/// AVCaptureSessionPreset640x480
/// AVCaptureSessionPresetiFrame960x540
/// AVCaptureSessionPreset1280x720
#pragma mark 预览分辨率 默认AVCaptureSessionPreset1280x720
@property (nonatomic, copy) NSString *resolutionSize;

#pragma mark 设置输出视频缩放样式
/// 设置输出视频缩放样式 在源和输出比例不一致时 是否加黑边 默认不加黑边
@property (nonatomic, assign) BOOL centerInside;

#pragma mark 设置是否默认使用前置采集
/// 设置是否默认使用前置采集
@property (nonatomic, assign) BOOL isFront;

#pragma mark 设置是否开启镜像
/// 设置是否开启镜像
@property (nonatomic, assign) BOOL isOrientation;

#pragma mark 显示方向 默认UIInterfaceOrientationPortrait(竖屏显示)
/// 显示方向
@property(nonatomic, assign) UIInterfaceOrientation outputImageOrientation;
/* ****************** ⬆️ AGC AEC sampe 编码参数设置(选填项) ⬆️ ****************** */


#pragma mark - 会控属性设置
/* ****************** ⬇️ 会控属性设置 ⬇️ ****************** */
#pragma mark 硬件解码 YES开启 NO关闭
@property (nonatomic, assign) BOOL isHardwarede;
#pragma mark 网络自适应延迟 YES开启 NO关闭
@property (nonatomic, assign) BOOL isAdaptation;
#pragma mark 码率自适应 YES开启 NO关闭
@property (nonatomic, assign) BOOL isCodeRate;
#pragma mark 音频状态 YES开启 NO关闭
@property (nonatomic, assign) BOOL isOpenAudio;
#pragma mark 视频状态 YES开启 NO关闭
@property (nonatomic, assign) BOOL isOpenVideo;
/* ****************** ⬆️ 会控属性设置 ⬆️ ****************** */

@end
```

### 视频会议服务API
```
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
@property (nonatomic, strong) Account *account;


#pragma mark - -------- 视频会议基础接口 ---------
#pragma mark 单例模式初始化流媒体服务类
+ (VCSMeetingManager *)sharedManager;

#pragma mark 初始化会议SDK(YES-连接成功，NO-连接失败)
/// 初始化会议SDK(YES-连接成功，NO-连接失败)
/// @param meetingParam 会控参数
/// @param delegate 代理
- (BOOL)initMediaSessionWithMeetingParam:(VCSMeetingParam *)meetingParam delegate:(id)delegate;

#pragma mark 获取SDK版本信息
/// 获取SDK版本信息
- (NSString *)getVersionInfo;

#pragma mark 销毁释放视频会议资源
/// 销毁释放视频会议资源
- (void)destroy;


#pragma mark - -------- 视频会议流媒体服务相关接口 ---------
#pragma mark 关闭/开启音频(是否发送音频)
/// 关闭/开启音频(是否发送音频)
/// @param state 设备状态
- (NSInteger)enableSendAudio:(DeviceState)state;

#pragma mark 关闭/开启视频(是否发送视频)
/// 关闭/开启视频(是否发送视频)
/// @param state 设备状态
- (NSInteger)enableSendVideo:(DeviceState)state;

#pragma mark 关闭/开启接收音频(是否接收音频)
/// 关闭/开启接收音频(是否接收音频)
/// @param otherClientId 目标UID
/// @param enabled 1-接收 0-不接收
- (NSInteger)enableRecvAudioUid:(int)otherClientId enabled:(int)enabled;

#pragma mark 关闭/开启接收视频(是否接收视频)
/// 关闭/开启接收视频(是否接收视频)
/// @param otherClientId  目标UID
/// @param enabled 1-接收 0-不接收
- (NSInteger)enableRecvVideoUid:(int)otherClientId enabled:(int)enabled;

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

#pragma mark 设置将用户流转发给与会者(选择所需的用户流转发给与会者)
/// 设置将用户流转发给与会者(选择所需的用户流转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 0-关闭转发, 1-音频流, 2-视频流, 3-音视频流
- (void)setStreamAcceptWithClientId:(int)clientId mark:(int)mark;

#pragma mark 设置不将用户流转发给与会者(滤特定用户的流不转发给与会者)
/// 设置不将用户流转发给与会者(滤特定用户的流不转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 0-关闭过滤, 1-音频流, 2-视频流, 3-音视频流
- (void)setStreamFilterWithClientId:(int)clientId mark:(int)mark;

#pragma mark 设置用户特定的子码率(轨道)转发给与会者(选择特定用户的特定的子码率(轨道)转发给与会者)
/// 设置用户特定的子码率(轨道)转发给与会者(选择特定用户的特定的子码率(轨道)转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 1-选择转发0视频轨, 2-选择转发1视频轨, 5=选择转发0和2视频轨
- (void)setStreamTrackWithClientId:(int)clientId mark:(int)mark;

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

#pragma mark - -------- 视频会议本地采集相关接口 ---------
#pragma mark 获得当前视频采集的本地预览层
/// 获得当前视频采集的本地预览层
- (nullable UIView *)localPreview;

#pragma mark 加载VideoCapture实例
/// 加载VideoCapture实例
/// @param displayView 本地摄像头预览层
- (void)onLocalDisplayViewReady:(UIView *)displayView;

#pragma mark 开始推流(开始本地摄像头视频采集)
/// 开始推流(开始本地摄像头视频采集)
- (void)startCameraCapture;

#pragma mark 停止推流(停止本地摄像头视频采集)
/// 停止推流(停止本地摄像头视频采集)
- (void)stopCameraCapture;

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

#pragma mark 是否有多个摄像头
/// 是否有多个摄像头
- (BOOL)hasMultipleCameras;

#pragma mark 获取实际的采集大小
/// 获取实际的采集大小
- (CGSize)getRealCaptureSize;

#pragma mark 手动聚焦
/// 手动聚焦
/// @param point 标点
- (void)setFocusAtPoint:(CGPoint)point;


#pragma mark - -------- 视频会议互动消息服务相关接口 ---------
#pragma mark 更新心跳(自身状态变化时需要及时调用此方法)
- (void)renewMyAccountHeartBeat;

#pragma mark 发送文本消息
/// 发送文本消息
/// @param message 消息内容
/// @param targetId 目标用户ID(不传代表发送给会议室全体人员)
- (void)sendTextChatWithMessage:(nullable NSString *)message targetId:(nullable NSString *)targetId;

#pragma mark 发送主持人踢人消息
/// 发送主持人踢人消息
/// @param targetId 目标用户ID(返回NO 代表没有权限执行此操作)
- (BOOL)sendKickoutWithTargetId:(nullable NSString *)targetId;

#pragma mark 发送主持人禁用/开启音频消息
/// 发送主持人禁用/开启音频消息
/// @param targetId 目标用户ID
/// @param isProhibit YES-禁用 NO-开启(返回NO 代表没有权限执行此操作)
- (BOOL)sendKostCtrlAudioWithTargetId:(nullable NSString *)targetId isProhibit:(BOOL)isProhibit;

#pragma mark 发送主持人禁用/开启视频消息
/// 发送主持人禁用/开启视频消息
/// @param targetId 目标用户ID
/// @param isProhibit YES-禁用 NO-开启(返回NO 代表没有权限执行此操作)
- (BOOL)sendKostCtrlVideoWithTargetId:(nullable NSString *)targetId isProhibit:(BOOL)isProhibit;

#pragma mark 主持人设置白板状态(打开或关闭)
/// 主持人设置白板状态(打开或关闭)
/// @param openState 是否打开状态(YES-打开，NO-关闭)(返回NO 代表没有权限执行此操作)
- (BOOL)setRoomWhiteBoardStateWithOpenState:(BOOL)openState;

#pragma mark 推送码流发生变化
/// 推送码流发生变化
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
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
/// @param stream 码流信息(返回NO 代表没有权限执行此操作)
- (BOOL)hostChangedRoomStreamWithTargetId:(NSString *)targetId operation:(Operation)operation stream:(Stream *)stream;

@end
```

### 视频会议服务API代理方法回调
```
#pragma mark - 本地采集相关代理
@protocol VCSMeetingManagerCameraProtocol <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark 点击视频采集窗口
/// 点击视频采集窗口
/// @param tag 标记
/// @param tapCount 双击&单击
- (void)cameraViewTouchWithTag:(CGFloat)tag tapcount:(int)tapCount;

@end

#pragma mark - 视频会议相关代理
@protocol VCSMeetingManagerProtocol <NSObject>

#pragma mark 可选实现代理方法
@optional

#pragma mark - -------- 流媒体服务相关代理 --------
#pragma mark 会议室流媒体码率自适应状态(码率变化回调)
/// 会议室流媒体码率自适应状态(码率变化回调)
/// @param streamData 流媒体信息
- (void)roomXbitrateChangeWithStreamData:(NSDictionary *)streamData;

#pragma mark 会议室当前用户上传流媒体状态回调
/// 会议室当前用户上传流媒体状态回调
/// @param ptr 底层防止溢出字段
/// @param streamData 流媒体信息(delay : 上传延迟时间 speed : 上传发送速度 status : -1上传出错 >=0正常 buffer : 上传缓冲包0-4正常 overflow : 上传缓冲包0-4正常)
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

#pragma mark 会议室与会人摄像头视频数据回调(可根据不同linkId显示/处理窗口)
/// 会议室与会人摄像头视频数据回调(可根据不同linkId显示/处理窗口)
/// @param linkId 视频链路ID
/// @param track 视频轨道
/// @param type 视频存储格式(0 - I420 , 1 - NV12, 2 - NV21)
/// @param width 宽/高
/// @param height 宽/高
/// @param yData 流媒体像素数据
/// @param uData 流媒体像素数据
/// @param vData 流媒体像素数据
- (void)roomParticipantCameraDataWithLinkId:(int)linkId track:(int)track type:(int)type width:(int)width height:(int)height yData:(void *)yData uData:(void *)uData vData:(void *)vData;


#pragma mark - -------- 互动服务服务相关代理 --------
#pragma mark 互动服务连接失败(进入房间失败)
/// 互动服务连接失败(进入房间失败)
/// @param command cmd指令
- (void)roomListenRoomEnterFailedCommand:(Command)command;

#pragma mark 会议室状态通知
/// 会议室状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomStateWithNotify:(RoomNotify *)notify error:(NSError *)error;

#pragma mark 成员状态通知
/// 成员状态通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenAccountStateWithNotify:(AccountNotify *)notify error:(NSError *)error;

#pragma mark 被踢出房间通知
/// 被踢出房间通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenKickoutWithNotify:(KickoutNotify *)notify error:(NSError *)error;

#pragma mark 成员进入会议室通知
/// 成员进入会议室通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenEnterWithNotify:(EnterNotify *)notify error:(NSError *)error;

#pragma mark 成员退出会议室通知
/// 成员退出会议室通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenExitWithNotify:(ExitNotify *)notify error:(NSError *)error;

#pragma mark 会议开始通知
/// 会议开始通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomBeginWithNotify:(RoomBeginNotify *)notify error:(NSError *)error;

#pragma mark 会议结束通知
/// 会议结束通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenRoomEndedWithNotify:(RoomEndedNotify *)notify error:(NSError *)error;

#pragma mark 我的状态变化通知
/// 我的状态变化通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenMyAccountWithNotify:(MyAccountNotify *)notify error:(NSError *)error;

#pragma mark 码流变化通知
/// 码流变化通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenStreamChangedWithNotify:(StreamNotify *)notify error:(NSError *)error;

#pragma mark 透传消息通知
/// 透传消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenPassthroughWithNotify:(PassthroughNotify *)notify error:(NSError *)error;

#pragma mark 主持人操作码流通知
/// 主持人操作码流通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenHostCtrlStreamWithNotify:(HostCtrlStreamNotify *)notify error:(NSError *)error;

#pragma mark 聊天消息通知
/// 聊天消息通知
/// @param notify 通知信息
/// @param error 错误信息
- (void)onListenChatWithNotify:(ChatNotify *)notify error:(NSError *)error;

@end
```

### 音视频流播放器
```
@interface RTYUVPlayer : UIView
{
}
#pragma mark - 接口
//- (void)displayYUVData:(void *)pic; //废除
// track:视频轨道 type:[0 I420 ,1 NV12 2 NV21]
- (void)displayYUVData:(int)track type:(int)type width:(int)width height:(int)height yData:(void *)yData uData:(void*)uData vData:(void*)vData;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;
- (void)clearFrame; //
- (void)ZoomFull:(BOOL)zooml;//是否全屏显示，如果全屏那么需要计算坐标
- (void)SetScal:(BOOL)scal;//YES: 加黑边，否则不加黑边  //this will be removed in next version
-(void)setImageScaleType:(int)type;//设置image view 方式 默认CENTERINSIDE
- (void)SetLayoutReset:(BOOL)set;//YES 计算
@property (weak, nonatomic) id<RTYUVPlayerDelegate>delegate;
@property(nonatomic, assign) int windowWidth;
@property(nonatomic, assign) int windowHeight;
@property(nonatomic,assign)int tmpWindowsWidth;
@property(nonatomic,assign)int tmpWindowsHeight;
@property(nonatomic,assign)int dWidth;//归一化大小
@property(nonatomic,assign)int dHeight;//归一化大小
@property(nonatomic,assign)int srcWidth;//原始大小
@property(nonatomic,assign)int srcHeight;//原始大小
@property(nonatomic,assign)int tmpVideoWidth;
@property(nonatomic,assign)int tmpVideoHeight;
@property(nonatomic,assign)BOOL scal;// YES center_inside  NO:center_grop
@property(nonatomic,assign)int showType;
@property(nonatomic,assign)BOOL resetLayout;//重新计算

@end
```

### 音视频流播放器代理方法回调
```
@protocol RTYUVPlayerDelegate<NSObject>
/// layout 单击 双击
- (void)viewtouchtag:(CGFloat)tag tapcount:(int)tapCount;
@end
```

## SDK参数说明

### 会控参数说明
| 参数 | 类型 | 描述 |
| --- | --- | --- |
| currentSdkNo | int | 当前用户登录SDK编号(自己房间ID) |
| accountId | NSString | 当前用户平台ID |
| name | NSString | 当前用户用户名 |
| nickname | NSString | 当前用户用户昵称 |
| portrait | NSString | 当前用户用户头像 |
| session | NSString | 入会凭证 |
| sdkNo | int | 进入房间SDK编号 |
| roomId | NSString | 进入房间ID |
| streamHost | NSString | 流媒体服务地址 |
| streamPort | int | 流媒体服务端口 |
| meetingHost | NSString | 互动服务器地址 |
| meetingPort | int | 互动服务器端口 |
| maxConnectDuration | int | 互动服务器异常重连最大时间(默认30s) |
| AGC | int | AGC 默认16000 |
| AEC | int | AEC 默认12 |
| Sampe | int | 采样率 默认48000 |
| outWidth | int | 输出分辨率宽 默认848 |
| outHeight | int | 输出分辨率高 默认480 |
| resolutionSize | NSString | 预览分辨率 默认AVCaptureSessionPreset1280x720 |
| centerInside | BOOL | 设置输出视频缩放样式 在源和输出比例不一致时 是否加黑边 默认不加黑边 |
| isFront | BOOL | 设置是否默认使用前置采集 |
| isOrientation | BOOL | 设置是否开启镜像 |
| outputImageOrientation | UIInterfaceOrientation | 显示方向 默认UIInterfaceOrientationPortrait(竖屏显示) |
| isHardwarede | BOOL | 硬件解码 YES开启 NO关闭 |
| isAdaptation | BOOL | 网络自适应延迟 YES开启 NO关闭 |
| isCodeRate | BOOL | 码率自适应 YES开启 NO关闭 |
| isOpenAudio | BOOL | 自己音频状态 YES开启 NO关闭 |
| isOpenVideo | BOOL | 视频状态 YES开启 NO关闭 |

### 操作返回结果状态参数说明
| 宏 | 值 | 描述 |
| --- | :---: | --- |
| VCSEnterMeetingResultStateSuccess | 200 |  入会成功 |
| VCSEnterMeetingResultStateInitialStreamFail | 1 | 设置初始推流码率失败 |
| VCSEnterMeetingResultStateCreateRoomFail | 2 | 初始创建房间失败 |
| VCSEnterMeetingResultStateEnterRoomFail | 3 | 进入房间首次推流失败 |
| VCSEnterMeetingResultStatePushStreamFail | 9999 | 进入房间持续推流失败 |

### 视频会议基础接口
#### 获取视频会议单例对象

1. 方法函数

```
#pragma mark 单例模式初始化视频会议服务类
+ (VCSMeetingManager *)sharedManager;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | VCSMeetingManager | SDK服务对象 |

#### 获取版本号

1. 方法函数

```
#pragma mark 获取SDK版本信息
- (NSString *)getVersionInfo;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | NSString | SDK版本信息 |

#### 初始化会议SDK

1. 方法函数

```
#pragma mark 初始化会议SDK(YES-连接成功，NO-连接失败)
/// 初始化会议SDK(YES-连接成功，NO-连接失败)
/// @param meetingParam 会控参数
/// @param delegate 代理
- (BOOL)initMediaSessionWithMeetingParam:(VCSMeetingParam *)meetingParam delegate:(id)delegate;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| meetingParam | VCSMeetingParam | 会控参数 |
| delegate | id | 设置代理 |

#### 销毁释放会议资源

1. 方法函数

```
#pragma mark 销毁释放视频会议资源
/// 销毁释放视频会议资源
- (void)destroy;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 结束会议后释放会议资源 |

### 视频会议流媒体接口
#### 关闭/开启发送音频

1. 方法函数

```
#pragma mark 关闭/开启音频(是否发送音频)
/// 关闭/开启音频(是否发送音频)
/// @param state 设备状态
- (NSInteger)enableSendAudio:(DeviceState)state;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| state | DeviceState | 是否发送 |

#### 关闭/开启发送视频

1. 方法函数

```
#pragma mark 关闭/开启视频(是否发送视频)
/// 关闭/开启视频(是否发送视频)
/// @param state 设备状态
- (NSInteger)enableSendVideo:(DeviceState)state;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| state | DeviceState | 是否发送 |

#### 关闭/开启接收音频

1. 方法函数

```
#pragma mark 关闭/开启接收音频(是否接收音频)
/// 关闭/开启接收音频(是否接收音频)
/// @param otherClientId 目标UID
/// @param enabled 1-接收 0-不接收
- (NSInteger)enableRecvAudioUid:(int)otherClientId enabled:(int)enabled;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| otherClientId | int | 目标UID(为0 表示所有其他与者) |
| enabled | int | 1-接收 0-不接收 |

#### 关闭/开启接收视频

1. 方法函数

```
#pragma mark 关闭/开启接收视频(是否接收视频)
/// 关闭/开启接收视频(是否接收视频)
/// @param otherClientId  目标UID
/// @param enabled 1-接收 0-不接收
- (NSInteger)enableRecvVideoUid:(int)otherClientId enabled:(int)enabled;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| otherClientId | int | 目标UID(为0 表示所有其他与者) |
| enabled | int | 1-接收 0-不接收 |

#### 获取当前设备是否支持硬件解码

1. 方法函数

```
#pragma mark 获取当前设备是否支持硬件解码(0-不支持, 1-支持)
- (NSInteger)getHardwareSupport;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | NSInteger | 0-不支持, 1-支持 |

#### 获取当前解码类型

1. 方法函数

```
#pragma mark 获取当前解码类型(-1-未就绪, 0-软解, 1-硬件解码)
- (NSInteger)getCurrentDecoder;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | NSInteger | -1-未就绪, 0-软解, 1-硬件解码 |

#### 设置是否使用双码流

1. 方法函数

```
#pragma mark 设置是否使用双码流
/// 设置是否使用双码流
/// @param isUse YES-使用双码流 NO-使用单码流
- (void)setMultiStream:(BOOL)isUse;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| isUse | BOOL | YES-使用双码流 NO-使用单码流 |

#### 设置是否使用高清码流

1. 方法函数

```
#pragma mark 设置是否关闭高清码流
/// 设置是否关闭高码流
/// @param isClose YES-使用高码流 NO-不使用高码流
- (void)setCloseHighStream:(BOOL)isClose;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| isClose | BOOL |  YES-使用高码流 NO-不使用高码流 |

#### 设置将用户流转发给与会者

1. 方法函数

```
#pragma mark 设置将用户流转发给与会者(选择所需的用户流转发给与会者)
/// 设置将用户流转发给与会者(选择所需的用户流转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 0-关闭转发, 1-音频流, 2-视频流, 3-音视频流
- (void)setStreamAcceptWithClientId:(int)clientId mark:(int)mark;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| clientId | int | 与会者ID(为0时代表所有与会者) |
| mark | int | 0-关闭转发, 1-音频流, 2-视频流, 3-音视频流 |

#### 设置不将用户流转发给与会者

1. 方法函数

```
#pragma mark 设置不将用户流转发给与会者(滤特定用户的流不转发给与会者)
/// 设置不将用户流转发给与会者(滤特定用户的流不转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 0-关闭过滤, 1-音频流, 2-视频流, 3-音视频流
- (void)setStreamFilterWithClientId:(int)clientId mark:(int)mark;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| clientId | int | 与会者ID(为0时代表所有与会者) |
| mark | int | 0-关闭转发, 1-音频流, 2-视频流, 3-音视频流 |

#### 设置用户特定的子码率(轨道)转发给与会者

1. 方法函数

```
#pragma mark 设置用户特定的子码率(轨道)转发给与会者(选择特定用户的特定的子码率(轨道)转发给与会者)
/// 设置用户特定的子码率(轨道)转发给与会者(选择特定用户的特定的子码率(轨道)转发给与会者)
/// @param clientId 所有与会者或与会者ID
/// @param mark 1-选择转发0视频轨, 2-选择转发1视频轨, 5=选择转发0和2视频轨
- (void)setStreamTrackWithClientId:(int)clientId mark:(int)mark;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| clientId | int | 与会者ID(为0时代表所有与会者) |
| mark | int | 1-选择转发0视频轨, 2-选择转发1视频轨, 5=选择转发0和2视频轨 |

#### 开启远程调试

1. 方法函数

```
#pragma mark 开启远程调试
/// 开启远程调试
/// @param address 地址
/// @param level 日志级别-3
- (void)openDebuggerWithAddress:(NSString *)address level:(int)level;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| address | NSString | 调试地址 |
| level | int | 日志级别 |

#### 打印调试日志

1. 方法函数

```
#pragma mark 打印调试日志
/// 打印调试日志
/// @param printInfo 打印信息
- (void)debuggerPrint:(NSString *)printInfo;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| printInfo | NSString | 打印信息 |

#### 关闭远程调试

1. 方法函数

```
#pragma mark 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
/// 关闭远程调试(只有开启远程调试的时候才可以使用此方法)
- (void)closeDebugger;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 关闭远程调试(只有开启远程调试的时候才可以使用此方法) |

### 视频会议本地采集接口
#### 获得当前视频采集的本地预览层

1. 方法函数

```
#pragma mark 获得当前视频采集的本地预览层
/// 获得当前视频采集的本地预览层
- (nullable UIView *)localPreview;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 获得当前视频采集的本地预览层 |

#### 加载VideoCapture实例

1. 方法函数

```
#pragma mark 加载VideoCapture实例
/// 加载VideoCapture实例
/// @param displayView 本地摄像头预览层
- (void)onLocalDisplayViewReady:(UIView *)displayView;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| displayView | UIView | 加载VideoCapture实例 |

#### 开始推流(开始本地摄像头视频采集)

1. 方法函数

```
#pragma mark 开始推流(开始本地摄像头视频采集)
/// 开始推流(开始本地摄像头视频采集)
- (void)startCameraCapture;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 开始本地摄像头视频采集并开始推流 |

#### 停止推流(停止本地摄像头视频采集)

1. 方法函数

```
#pragma mark 停止推流(停止本地摄像头视频采集)
/// 停止推流(停止本地摄像头视频采集)
- (void)stopCameraCapture;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 停止本地摄像头视频采集并停止推流 |

#### 设置视频曝光率

1. 方法函数

```
#pragma mark 设置视频曝光率
/// 设置视频曝光率
/// @param value 曝光值(-8.0~8.0)
- (void)setVideoExposure:(float)value;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| value | float | 曝光值(-8.0~8.0) |

#### 设置镜头拉伸

1. 方法函数

```
#pragma mark 设置镜头拉伸
/// 设置镜头拉伸
/// @param value 拉伸值(1.0~5.0)
- (void)setCameraZoomFatory:(float)value;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| value | float | 拉伸值(1.0~5.0) |

#### 切换摄像头(前置or后置)

1. 方法函数

```
#pragma mark 切换摄像头(前置or后置)
/// 切换摄像头(前置or后置)
- (void)switchCamera;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 切换摄像头(前置or后置) |

#### 打开/关闭闪光灯

1. 方法函数

```
#pragma mark 打开/关闭闪光灯
/// 打开/关闭闪光灯
/// @param isOpen YES-打开 NO-关闭
- (BOOL)flashlightCamera:(BOOL)isOpen;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| isOpen | BOOL | 打开/关闭闪光灯 |

#### 启用自动闪光灯

1. 方法函数

```
#pragma mark 启用自动闪光灯
/// 启用自动闪光灯
- (void)setFlashlightAuto;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 启用自动闪光灯 |

#### 判断前置摄像头是否可用

1. 方法函数

```
#pragma mark 判断前置摄像头是否可用
/// 判断前置摄像头是否可用
- (BOOL)isFrontCameraAvailable;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 判断前置摄像头是否可用 |

#### 判断后置摄像头是否可用

1. 方法函数

```
#pragma mark 判断后置摄像头是否可用
/// 判断后置摄像头是否可用
- (BOOL)isBackCameraAvailable;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 判断后置摄像头是否可用 |

#### 判断设备是否有摄像头

1. 方法函数

```
#pragma mark 判断设备是否有摄像头
/// 判断设备是否有摄像头
- (BOOL)isCameraAvailable;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 判断设备是否有摄像头 |

#### 判断设备是否有多个摄像头

1. 方法函数

```
#pragma mark 判断设备是否有多个摄像头
/// 是否有多个摄像头
- (BOOL)hasMultipleCameras;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 判断设备时候有多个摄像头 |

#### 获取实际的采集大小

1. 方法函数

```
#pragma mark 获取实际的采集大小
/// 获取实际的采集大小
- (CGSize)getRealCaptureSize;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| 无 | 无 | 获取实际的采集大小 |

#### 手动聚焦

1. 方法函数

```
#pragma mark 手动聚焦
/// 手动聚焦
/// @param point 标点
- (void)setFocusAtPoint:(CGPoint)point;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| point | CGPoint | 标点 |

### 视频会议互动消息接口
#### 发送文本消息

1. 方法函数

```
#pragma mark 发送文本消息
/// 发送文本消息
/// @param message 消息内容
/// @param targetId 目标用户ID(不传代表发送给会议室全体人员)
- (void)sendTextChatWithMessage:(nullable NSString *)message targetId:(nullable NSString *)targetId;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| message | NSString | 消息内容 |
| targetId | NSString | 目标用户ID(不传代表发送给会议室全体人员) |

#### 发送主持人踢人消息

1. 方法函数

```
#pragma mark 发送主持人踢人消息
/// 发送主持人踢人消息
/// @param targetId 目标用户ID(返回NO 代表没有权限执行此操作)
- (BOOL)sendKickoutWithTargetId:(nullable NSString *)targetId;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| targetId | NSString | 目标用户ID(返回NO 代表没有权限执行此操作) |

#### 发送主持人禁用/开启音频消息

1. 方法函数

```
#pragma mark 发送主持人禁用/开启音频消息
/// 发送主持人禁用/开启音频消息
/// @param targetId 目标用户ID
/// @param isProhibit YES-禁用 NO-开启(返回NO 代表没有权限执行此操作)
- (BOOL)sendKostCtrlAudioWithTargetId:(nullable NSString *)targetId isProhibit:(BOOL)isProhibit;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| targetId | NSString | 目标用户ID |
| isProhibit | BOOL | YES-禁用 NO-开启(返回NO 代表没有权限执行此操作) |

#### 发送主持人禁用/开启视频消息

1. 方法函数

```
#pragma mark 发送主持人禁用/开启视频消息
/// 发送主持人禁用/开启视频消息
/// @param targetId 目标用户ID
/// @param isProhibit YES-禁用 NO-开启(返回NO 代表没有权限执行此操作)
- (BOOL)sendKostCtrlVideoWithTargetId:(nullable NSString *)targetId isProhibit:(BOOL)isProhibit;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| targetId | NSString | 目标用户ID |
| isProhibit | BOOL | YES-禁用 NO-开启(返回NO 代表没有权限执行此操作) |

#### 主持人设置白板状态(打开或关闭)

1. 方法函数

```
#pragma mark 主持人设置白板状态(打开或关闭)
/// 主持人设置白板状态(打开或关闭)
/// @param openState 是否打开状态(YES-打开，NO-关闭)(返回NO 代表没有权限执行此操作)
- (BOOL)setRoomWhiteBoardStateWithOpenState:(BOOL)openState;
```

2. 参数说明
| 参数 | 类型 | 描述 |
| --- | --- | --- |
| openState | BOOL | 主持人设置白板状态(打开或关闭) |

#### 推送码流发生变化

1. 方法函数

```
#pragma mark 推送码流发生变化
/// 推送码流发生变化
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息
- (void)changedRoomStreamWithOperation:(Operation)operation stream:(Stream *)stream;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| operation | Operation | 操作指令(0-关闭，1-打开，2-修改) |
| stream | Stream | 码流信息 |

#### 发送透传消息(自定义消息)

1. 方法函数

```
#pragma mark 发送透传消息(自定义消息)
/// 发送透传消息(自定义消息)
/// @param targetId 目标用户
/// @param message 自定义消息
- (void)sendRoomPassthroughWithTargetId:(NSString *)targetId message:(NSString *)message;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| targetId | NSString | 目标用户 |
| message | NSString | 自定义消息 |

#### 主持人变更码流

1. 方法函数

```
#pragma mark 主持人变更码流
/// 主持人变更码流
/// @param targetId 目标用户
/// @param operation 操作指令(0-关闭，1-打开，2-修改)
/// @param stream 码流信息(返回NO 代表没有权限执行此操作)
- (BOOL)hostChangedRoomStreamWithTargetId:(NSString *)targetId operation:(Operation)operation stream:(Stream *)stream;
```

2. 参数说明

| 参数 | 类型 | 描述 |
| --- | --- | --- |
| targetId | NSString | 目标用户 |
| operation | Operation | 操作指令(0-关闭，1-打开，2-修改) |
| stream | Stream | 码流信息(返回NO 代表没有权限执行此操作) |

## SDK初始化
```
/// 初始化SDK
BOOL isSucceed = [[VCSMeetingManager sharedManager] initMediaSessionWithMeetingParam:self.meetingParam delegate:self];
if (isSucceed) {
    /// 初始化SDK成功(添加视频采集画面并开始推流)
    [self.cameraPlayerView addSubview:self.playerView];
} else {
    NSLog(@"++++++++++互动服务器连接失败可再次做重连操作");
    // 不需要重连直接调用退出
    [self dismiss];
}
```

## SDK本地采集及其推流
```
#pragma mark - 设置属性
- (void)stepConfig {
    
    /// 加载本地采集预览
    [self insertSubview:self.cameraView atIndex:0];
    /// 默认采集大图
    self.isShowMaxVideoState = YES;
    /// 设置采集窗口代理
    [VCSMeetingManager sharedManager].cameraDelegate = self;
    /// 视图添加相机采集
    [[VCSMeetingManager sharedManager] onLocalDisplayViewReady:self.cameraView];
    /// 开始推流
    [[VCSMeetingManager sharedManager] startCameraCapture];
    /// 添加采集对象到维护数据
    [self.playArray addObject:[[VCSMeetingManager sharedManager] localPreview]];
    /// 视图添加视频父组件
    [self addSubview:self.scrollView];
}
```

## SDK参会小窗口
```
参会小窗口依然沿用RTYUVPlayer类进行渲染展示；
详见Demo FWPlayerView与FWYUVPlayerView 对象。
```

## SDK资源回收
```
#pragma mark - 退出(离开此页面)
- (void)dismiss {
    
    /// 销毁释放会议资源
    [[VCSMeetingManager sharedManager] destroy];
    /// 返回上级目录
    [self.navigationController popViewControllerAnimated:YES];
}
```

## 版本更新日志

| 版本信息  | 日期         | 说明        |
| ---------|:-----------:| ----------:|
| 0.1.1    | 2020.05.14  | 会控参数类(VCSMeetingParam)新增视频采集参数centerInside、isFront、isOrientation、outputImageOrientation，注释详见VCSMeetingParam.h 80行~95行行，用法详见FWRoomConfigViewModel.m 76行~79行；|
| 0.1.0    | 2020.05.12  | 原会控参数类名(VCSMeetingControl)更改(VCSMeetingParam)并新增参数outWidth、outHeight、resolutionSize，详见VCSMeetingParam.h 66行，用法详见FWRoomConfigViewModel.m 72行；原暴露接口分为流媒体服务(VCSMeetingManager)、互动服务(VCSMeetingModel)，现统一整合视频会议服务(VCSMeetingManager)，详见Demo用法；原本地采集对象由业务层管理修改为由SDK管理，使用方式参见Demo FWPlayerView.m 52行；原SDK互动消息监听事件解析消息信息体代理修改为单独消息回调，详见Demo FWRoomViewController.m 320行~450行。 |
| 0.0.8    | 2020.05.07  | SDK内部使用互动服务心跳方法更换名称&部分注释完善 |
| 0.0.7    | 2020.05.06  | 新增流媒体码率自适应状态(码率变化回调) |
| 0.0.6    | 2020.05.05  | 设置初始推流参数回调参数统一使用返回结果状态常量 |
| 0.0.5    | 2020.05.01  | 更改对外提供头文件引用方式 |
| 0.0.4    | 2020.04.30  | 新增架构模块切片 |
| 0.0.3    | 2020.04.29  | SDK内部注释整改满足appledoc规范 |
| 0.0.2    | 2020.04.28  | 对外提供接口更换OC规范便于检索和使用 |
| 0.0.1    | 2020.04.27  | 重构SDK架构集成方式新增自动集成 |


## 常见问题

1、初次使用SDK，出现白屏或者闪屏问题。
> 使用之前，需要对手机权限进行检测（麦克风与相机等）

2、SDK在使用期间，出现闪退问题。
> 在播放对方视频窗口时，必须进行视频流信息释放（free）

3、新建工程中，Demo中接口数据请求失败问题。
> 检查工程配置中，网络权限是否开启，要求必须开启。

4、SDK退出时，出现意外闪退问题。
> 在退出之前，需要对SDK内，视频的播放与采集进行释放，建议延迟1s内在退出当前VC。

5、SDK在使用中，无法接受其他人在房间内的消息问题。
> 在初始化SDK时，查看会议互动服务是否连接成功，心跳信息返回是否成功。如果存在失败，建议重新执行相关方法，或者退出重新进入会议。

6、SDK在使用中，本地采集回调引起闪退。
> 在对本地采集返回的pre对象进行判断，只有存在数据时，才可进行传输。

7、SDK在使用中，由于网路波动引起的进入闪退问题。
> 在进入会议时，SDK初始化之后，需要对互动服务链接状态进行判断，只有连接成功之后才可进行本地音视频数据进行采集，传输，步骤与流程需要完整一致。

8、SDK在使用中，使用互动服务器发送会控消息无法收到响应。
> 确保SDK处于最新版本的情况下，检查自己网络连接状态，如果都正常，可主动退出会议，或等待30s会收到退出会议提示。

9、集成会议SDK打包上传苹果商店失败问题。
> 目前SDK只支持arm64，请检查本地的工程配置，是否还有其他的支持，有的话请删除。

10、集成SDK，Build失败问题。
> 目前SDK最低版本支持9.0级以上Xcode 9.0以上。请确保配置达到要求。另外bitcode编译需要改为No。

11、SDK在使用中，主持人权限使用失败。
> 确保在本场会议中你的角色为主持人，并且发送的消息体是正确的NSData。

12、SDK在使用中，看到别人的画面突然卡住问题，听不到对方声音。
> 对方可能存在网络波动或者正在进行前后台台操作，视频是无法继续采集的。如果再此想听到对方声音，需要在Xcode工程中申请后台机制。

13、SDK在使用中，绘制他人窗口出现黑屏问题。
> 他人窗口在绘制过程中，需要对SDK底层返回的数据进行释放。无论做何种判断，必须在使用时一对一进行释放，可避免发生此种情况。

14、SDK在使用中，绘制他人窗口出现绿屏问题。
> 此种情况大多数出现在大小屏切换对应的大小码流时，在此种切换中，需要判断当前是否存在大码流，如果存在就播放大码流，不存在播放小码流，其他相对应逻辑不变。

15、SDK在使用中，外部通话(来电)处理问题。
> 根据自己的业务需求来实现，通过监听外部来电进行处理：
> 
> 1、直接退出会议，释放资源。
> 
> 2、当外部来电监听回调时，根据回调参数进行处理，来电关闭自己的音视频。处理完来电可以自行决定是否打开自己的音视频。

16、SDK在使用中，在切换大小码流时，返回的ID为0问题。
> 在返回回调的业务层处做判断规避此问题，如果ID为0，则忽略此处操作，其他逻辑不变。此种情况可能会出现在两个人在相同时间，一个推出同时另一个人进入可能会出现。

## Author

SailorGa, ljia789@gmail.com

## License

VCSSDK is available under the MIT license. See the LICENSE file for more info.
