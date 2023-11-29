//
//  anyliveAPI.h
//  AnyliveSDK
//
//  Created by huangkexing on 2019/4/25.
//  Copyright © 2019年 huangkexing. All rights reserved.
//
//IOS RTPlayer 我们为了方便用户自定义  这里我们将数据流 绑定ID的方式 网上送
#import <VideoToolbox/VideoToolbox.h>
#import <CoreData/CoreData.h>
#import <CoreMedia/CMSampleBuffer.h>

//事件
#define   VCS_CONNECT_EVENT       0x4E4E4F43 //连接事件
#define   VCS_MESSAGE             0x5353454D //消息事件
#define   VCS_XBITRATE            0x06    //码率自适应状态提示
#define   VCS_USER_JOIN_IN        0x10        //有人进入房间
#define   VCS_USER_EVENT_OUT      0x11        //有人离开房间
#define   VCS_STATIST_SEND        0x20        //自己上传流状态
#define   VCS_STATIST_RECV        0x21        //接收统计
#define   VCS_EVENT_RCV_NETREPT       7
#define   VCS_EVENT_RCV_XPROFILE       7  //接收网络状态
//network test
#define VCS_EVENT_PROBE_INFO 0x08

#define VCS_EVENT_ADAP_PROBE 0x09
#define VCS_EVENT_STATUS_SDP 0x02

//子事件

#define   VCS_UPLOAD_STATUS_NOMACFOUND  -6//事件属性 VCS_CONNECT_EVENT
#define   VCS_UPLOAD_STATUS_PACKERFAIL  -5 //事件属性 VCS_CONNECT_EVENT
#define   VCS_UPLOAD_STATUS_DNSERROR    -4 //事件属性 VCS_CONNECT_EVENT
#define   VCS_UPLOAD_STATUS_INITING      1 //事件属性 VCS_CONNECT_EVENT
#define   VCS_DISCONNECT                0x901  //事件属性 VCS_CONNECT_EVENT
#define   VCS_CONNECTING                0x902   //事件属性 VCS_CONNECT_EVENT
#define   VCS_CONNECTED                 0x903   //事件属性 VCS_CONNECT_EVENT
#define   VCS_CONNECT_FAIL              0x904   //事件属性 VCS_CONNECT_EVENT
#define   VCS_RE_CONNECTED              0x905   //事件属性 VCS_CONNECT_EVENT
#define   VCS_START_XBITRATE            0x3E8    //事件属性 VCS_XBITRATE
#define   VCS_BITRATE_RECOVERED         0x0      //事件属性 VCS_XBITRATE
#define   VCS_BITRATE_HALF_BITRATE      -1       //事件属性 VCS_XBITRATE
#define   VCS_BITRATE_QUARTER_BITRATE   -2     //事件属性 VCS_XBITRATE
#define   VIDEO_PUSH_INIT               0x82    //视频进入和退出

#define  VCS_RTMPUPLOADING_BEGIN    100    //开始推流
#define  VCS_RTMP_HANDSHAKE_FAIL    101    //握手失败

//显示
#define CENTERCROP 0x01
#define CENTERINSIDE 0x02
#define FITXY 0x00
#define FITSTART 0x03
#define FITEND 0x04


#define VIDEO_CAMERA_0        0x434d4130
#define VIDEO_CAMERA_90       0x434d4139
#define VIDEO_CAMERA_180      0x434d4131
#define VIDEO_CAMERA_270      0x434d4132

#define VIDEO_ESCREEN_0       0x45534e30
#define VIDEO_ESCREEN_90      0x45534e39
#define VIDEO_ESCREEN_180     0x45534e31
#define VIDEO_ESCREEN_270     0x45534e32

#define VIDEO_SCREEN_0        0x53454e30
#define VIDEO_SCREEN_90       0x53454e39
#define VIDEO_SCREEN_180      0x53454e31
#define VIDEO_SCREEN_270      0x53454e32

//audio info

#define RPT_AUDIOINF 0x22
#define RPT_SPEECH_STATE 10

//使用AAC编码 //moreAAC
#define AUDIO_ENCODE_AAC 0
//使用OPUS编码
#define  AUDIO_ENCODE_OPUS 0x5355504F


#define SPEAKER_ROUTER    0x5000
#define HEADSET_ROUTER    0x5001
#define BLUETHOOTH_ROUTER 0x5002
#define LINE_ROUTER       0x5003
#define UNKOWN_ROUTER     0x5004

#define USE_DENOISE   0x1000 // lparam =1 开启降噪 【默认开启】
#define USE_VADPROB   0x1001 // lparam=1 开启静音检查 【默认开启】

#define SAVE_FRAME_FOR_TEST 0x2000 //
#define VCS_OPT_AUDIOPRIO  0x030   // audio priority first



#define  VCS_SET_SAVEPATH 0x300 //for save path
//AEC 处理后 PCM，仅用于开启软件AEC 情况，示例：20220417130342_AEC.pcm
#define VCS_SET_SAVEAECPCM    0x302

//DEN 处理后 PCM，示例：20220417130342_MID.pcm[软件降噪才存在]
#define VCS_SET_SAVEDENPCM   0x303

//处理完毕后 PCM,就是编码前的PCM，示例：20220417130342_PRO.pcm
#define VCS_SET_SAVEPROPCM    0x304

//保存音频接收/解码
//音频帧，示例：20000004_20220417130342.aac
#define  VCS_SET_SAVERECVAUDIO  0x305

//解码后 PCM，示例：20000004_20220417130342.pcm
#define VCS_SET_SAVEDECPCM      0x306

//混音后 PCM，示例：20220417130342_MIX.pcm
#define VCS_SET_SAVEMIXPCM     0x307

// 弱网下可配置"接收自适应延迟"（推荐配合新版本流服务器）
#define VCS_SET_DEEPCONF     0x400

//系统初始化后设置音频出于非上传状态/或者上传状态，
#define VCS_SET_DEFNOSEND 0x308   //default send lparam = 0,lparam=1 nosend

/// encrypt
#define VCS_SET_ECPA 0x30a

//设置代理用于数据回调
@protocol callbackdataDelegate <NSObject>

//event
-(void)vcs_RoomEvent_Callback:(int)iEvent lparam:(int)lparam wparam:(int)wparam ptr:(NSString*)ptr;
//client frame
//- (void)vcs_Client_FrameCb:(int)linkId track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void*)uData vData:(void*)vData;

- (void)vcs_Client_FrameCb:(int)linkId stamp:(int)stamp track:(int)track type:(int)type lable:(int)lable width:(int)width height:(int)height yData:(void *)yData uData:(void*)uData vData:(void*)vData;

//audio status event
//new 2020/08/13
-(void)OnAudioStatusInfo:(int)iEvent lparam:(int)lparam wparam:(int)wparam ptr:(NSString*)ptr;

//video Orientation info cb
-(void)OnVideoOrientationInfo:(int)track lable:(int)lable;

-(void)OnAudioRouterInfo:(int)type info:(NSString*)info;
@end
@interface StaticAnyLibrary : NSObject
{
}
//API FUNNC
-(NSString*) VCS_getVersion;

-(NSString*) VCS_getDebugstr;

-(NSString*) VCS_getReturnstr;
//远程调试打开
-(NSInteger)VCS_openTrace:(NSString*)addr level:(int)level;
//关闭远程调试
-(NSInteger)VCS_closeTrace;
//打印日志
-(void)VCS_printTrace:(NSString*)info;
//生成唯一biaz
-(NSInteger)VCS_CreateToken:(NSString*)identifierStr;
//注册SDK环境 在VCS_Init 之前调用
-(void)VCS_RegisterSDK;
//初始化SDK
-(NSInteger) VCS_Init;
//释放SDK
-(NSInteger) VCS_Cleanup;
//设置输出大小 也就是推流大小 这个要和实际camera采集后输出大小一致
-(NSInteger) VCS_CreateVideoOutput:(int)iWidth outHeight:(int)iHeight Fps:(int)iFps vbirate:(int)iVbirate keyframe:(int)keyframes;

//设置音频编码码率 64K
-(NSInteger) VCS_CreateAudioOutput:(int)abitrate;
//关闭输出 关闭后 将停止推推
-(void) VCS_CloseOutput:(int)hOutput Close:(bool) isClose;
//设置系统AGC
-(NSInteger) VCS_SetOutputAgc:(int)hOutput AGC:(int) iAgc;
//设置系统AEC
-(NSInteger) VCS_SetOutputAec:(int)hOutput AEC:(int) iAec;
//创建会议
-(NSInteger) VCS_CreateRoom:(NSString*)szAddr port:(int) iPort room:(NSString*)szRoomNo token:(NSString*) szSessionId;
//会议消息代理 canCb=YES 时vcs_Cbf_RoomEvent 有效
-(NSInteger) VCS_SetRoomEvent:(int)hRoom cb:(bool)canCb;
//会议其他与会者数据代理 canCb=YES时 vcs_Pic_CallbackFrame有效
-(NSInteger) VCS_SetPicDataEvent:(int) hRoom cb:(bool)canCb;
//加入会议 iMyClientId 在同一个会议中必须具有唯一性
-(NSInteger) VCS_JoniRoom:(int)hRoom myId:(int)iMyClientId;
//退出会议
-(NSInteger) VCS_ExitRoom:(int)hRoom;
//发现自定义消息
-(NSInteger) VCS_SendMessage:(int)hRoom myId:(int)iMyClientId msg:(NSString*)szMessage;
//是否发送视频
-(NSInteger) VCS_EnableSendVideo:(int)hRoom myId:(int)iMyClientId   enabled:(int) iEnabled;
//时候发送音频
-(NSInteger) VCS_EnableSendAudio:(int)hRoom myId:(int)iMyClientId   enabled:(int)iEnabled;
//是否接收视频 iOtherClientId=0 表示所有其他与会者
-(NSInteger) VCS_EnableRecvVideo:(int)hRoom uId:(int)iOtherClientId enabled:(int) iEnabled;
//是否接收音频 iOtherClientId=0 表示所有其他与会者
-(NSInteger) VCS_EnableRecvAudio:(int)hRoom uId:(int)iOtherClientId enabled:(int) iEnabled;
//设置系统网络延时抖动 默认 1 [250ms]
-(NSInteger) VCS_SetRoomPlc:(int)hRoom plc:(int)iPlc;
//开启网络码率自适应 设置进行会议后 iSecond 开始启用 建议 设置[3,10]秒
-(NSInteger) VCS_SetRoomXBitrate:(int)hRoom sec:(int)iSecond;
//获取上传数据状态 通过 vcs_Cbf_RoomEvent 返回结果
-(void) VCS_GetUploadStatus;
//获取接收状态 通过 vcs_Cbf_RoomEvent 返回结果
-(void) VCS_GetRecvStatus;
//关联会议输出
-(NSInteger) VCS_SetRoomOutput:(int)hRoom output:(int)hOutput;
//获取渲染数据 通过vcs_Pic_CallbackFrame 返回
-(void)VCS_getClientFrame;
//往SDK送入视频数据 sampleBuffer 视频数据 视频大小  当前帧的时间戳
//-(NSInteger)VCS_PushVideoStream:(int)hRoom data:(CVPixelBufferRef)sampleBuffer imageW:(int)width imageH:(int)height stamp:(CMTime)stamp;
//
-(void)release_pic:(void*)pic;
//SDK 代理

//add 2019-11-16
//设置采样率
//支持 自设置采样率
-(void) VCS_setAudioSamplerate:(int)samplerate;
//new add 2019/09/18
//支持 自设 采样通道
-(void) VCS_setAudioChannels:(int)channles;
//new add 2019/09/18
//获取支持硬件解码 0 不支持 1 支持
-(NSInteger)VCS_getHWSupport;

//new add 2019/09/18
//是否启用硬件解码 默认启用
-(NSInteger)VCS_setUseHwDecoder:(BOOL) use;
//new add 2019/09/18
//获取当前解码 -1 未就绪 0 软解 1 硬件解码
-(NSInteger)VCS_getCurrentDecoder;
//new add 2019/09/18
//暂定发送音视频 可以在加入会议时不发送音视频使用【音视频还是需要向SDK送入】 设置不发送 那么 SDK 将不会向服务器发送音视频
-(NSInteger)VCS_SendPause:(int)Pause;
//add 2019-11-29

/*
 用于云端选择所需的用户流转发给与会者，命令格式：
 LMIC.picker=mask:linkmicId
 mask = 1 音频
 mask = 2 视频频
 mask = 3 音视频
 mask =0 关闭转发
 linkmicId = 0 代表所有与会者
 */
/*demo
 l转发 用户[12340001] 的音频流：
 LMIC.picker=1:12340001
 l转发 用户[12340001] 的视频流
 LMIC.picker=1:12340001
 l转发 用户[12340001] 的音视频流
 LMIC.picker=3:12340001
 l不转发 用户[12340001] 的流
 LMIC.picker=0:12340001
 l关闭选择转发模式：
 LMIC.picker=0:0
 */
-(void)VCS_set_picker:(int)mask Peer:(int)peer;

/*    用于云端过滤特定用户的流不转发给与会者，命令格式：
 LMIC.filter=mask:linkmicId
 mask = 1 音频
 mask = 2 视频频
 mask = 3 音视频
 mask = 0  关闭过滤
 linkmicId = 0 代表所有与会者
 */
/*demo
 l过滤 用户[12340001] 的音频：
 LMIC.filter=1:12340001
 l过滤 用户[12340001] 的视频：
 MIC.filter=2:12340001
 l过滤 用户[12340001] 的音视频：
 LMIC.filter=3:12340001
 l不过滤 用户[12340001] 的流：
 LMIC.filter=0:12340001
 l过滤 所有用户 的音频：
 LMIC.filter=1:0
 l过滤 所有用户 的视频：
 LMIC.filter=2:0
 l过滤 所有用户 的音视频：
 LMIC.filter=3:0
 l不过滤 所有用户 的流：
 LMIC.filter=0:0
 */
-(void )VCS_set_filter:(int)mask Peer:(int)peer;
/*
 用于云端选择特定用户的特定的子码率（轨道）转发给与会者，命令格式：
 LMIC.track=mask:linkmicId
 mask：二进制选择掩码
 1 1 1 1, 1 1 1 1
 轨道 0
 轨道 1
 轨道 2
 最多 7 个轨道
 示例：
 mask = 1 选择转发视频轨 0
 mask = 2 选择转发视频轨 1
 mask = 5 选择转发视频轨 0 和 2
 */
/*demo
 l转发 用户[12340001] 的视频轨[0]
 LMIC.track=1:12340001
 l转发 用户[12340001] 的视频轨[0] + 视频轨[2]
 LMIC.track=5:12340001
 l设置 所有用户 的默认转发视频轨
 LMIC.track=1:0
 */
-(void)VCS_set_track:(int)mask Peer:(int)peer;
//是否使用双流 默认使用 在 JoniRoom 之前设置 more为 true
-(void)VCS_Use_MultiStream:(BOOL)use;


//关闭高码流   默认  false
-(void)VCS_Close_High_Stream:(BOOL)close;
//自适应延时
-(void)VCS_Set_Xdelay:(int)set;

////设置输出旋转角度 在横竖屏前后置采集中旋转使用 //这个可有动态调整 默认不旋转 不镜像
-(void)VCS_setOutputRotateAndMirror:(int)value mirror:(BOOL)isMirror;
//new push
//-(NSInteger)VCS_PushVideoStream:(int)hRoom data:(CVPixelBufferRef)sampleBuffer  stamp:(CMTime)stamp;
//-(NSInteger)VCS_PushVideoStream:(int)hRoom data:(CVPixelBufferRef)sampleBuffer  stamp:(CMTime)stamp isFront:(BOOL) isFront;
-(NSInteger)VCS_PushVideoStream:(int)hRoom data:(CVPixelBufferRef)sampleBuffer  stamp:(CMTime)stamp isFront:(BOOL) isFront viewChange:(int)viewChange;
//是否自动加适应加黑边，在竖屏采集用可以设置加黑边 默认不自动适应加黑边
-(void)VCS_setVideoAutoFixBlackSide:(BOOL)fix;

//自定义默认轨道
-(NSInteger)VCS_setDefaultTrack:(int)track;
//pause send audio and videoå
-(NSInteger) VCS_StopSendAudioAndVideo:(int)pause;
//kitout
-(void)VCS_kickout:(int)clientId;

//录屏推流
//录屏编码数据推送 //如果时非编码模式
-(NSInteger)VCS_pushEncoderStream:(NSData*)StreamData stamp:(uint32_t)pts dts:(uint32_t)dts displayAngle:(int)angle;
//-(NSInteger)VCS_pushEncoderStream:(NSData*)StreamData stamp:(uint32_t)pts dts:(uint32_t)dts;
//是否关闭camera流推送。在非编码模式下有效 非编码模式录屏下必须通过该函数来却换流推送
-(void)VCS_CloseCameraStream:(BOOL)Close;
//录屏推流
-(NSInteger)VCS_pusScreanStreamd:(CVPixelBufferRef)sampleBuffer  stamp:(CMTime)stamp rotate:(int)value autofixblackSide:(BOOL)fix;


//new
//new add @2020/07/23

/**
 * No Picking Audio 接口
 * 人数多的会议，视频选择 4 方，音频选择所有发言者
 * stat:1 开启 0 关闭
 * @param stat
 */
-(void) VCS_No_Pick_Audio:(int)state;

//屏幕旋转触发SEI
-(void)VCS_update_SEI:(int)orientation;

//语音激励 upload
-(void)VCS_openVoiceExci:(BOOL)open;
//异步切换轨道
-(void) VCS_set_track_sync:(int)mask peer:(int)peer;

///2020/08/13
//查询接受音频状态
-(void) VCS_GetAudioRecvStatus;

//2020/08/20
/**
   speaker  default on
 */
-(void)VCS_setSpeakerOn:(BOOL)on;

/**
 *   设置音频编码方式 在进入进入会议前设置有效 ，不设置 将使用系统默认的AAC编码，
 *   使用AAC编码
 *    streamType::   AUDIO_ENCODE_AAC =0;
 *    使用OPUS编码
 *    treamType:: AUDIO_ENCODE_OPUS= 0x5355504F;
 * @param streamType
 * @return
 */
-(void )VCS_setAudioEncodeType:(int)streamType;

//add 2020/09/14

///new api
 //多码流轨道定义 0；低码流 1 高码率  2 录屏
//  二进制轨道  [111] 主要用来关闭和开启流是否送入发送队列，比如 001 那么这时候>只有轨道0的数据在发送【如果是多码流,那么就是低码流在发送】，
-(void) VCS_SendVideoStream:(int)mask;
 /*
该功能用于通知云端系统（例如 MCU），默认接收我的哪个轨道来做处理。
注意：
设置的同样为轨道掩码，
例如设置轨道 1 为默认轨道，则调用
// VCS_MCUDefaultTrack(2)
设置轨道 2 为默认轨道，则调用
// VCS_MCUDefaultTrack(4)
如果是多码流 默认设置了 track 1, 单码流默认设置了track 0
如果这你切换到了录屏 那么 我们需要告诉MCU 录屏的track 这时候我们可以设置 VCS_MCUDefaultTrack(4)
 之所以采用掩码是为了后续支持多个默认轨道
 */
-(void) VCS_MCUDefaultTrack:(int)defaultTrackMask;

//set push maxBitrate
//[kps  ex:2000 ]  set this value befor join room
-(void) VCS_SetPushMaxBitrate:(int)bitrate;
//路由切换
-(void)VCS_SwitchAudioRouter:(int)type;
//扩展参数设置设置接口
-(void)VCS_SetParams:(int)opt lparam:(int)lparam wparam:(int)wparam ptr:(void*)ptr;
//save frame for test VCS_SetParams:SAVE_FRAME_FOR_TEST lparam:1 wparam:0 [lparam >0 save =0 no save]
//audio pro  VCS_SetParams:SAVE_FRAME_FOR_TEST lparam:streamId wparam:0 [lparam =streamId wparam =1000  open  wparam=0 close]


  /**
     *     测速 测速是不可以上传数据流 也就是没有上传 但是会议地址必须配置的  测
试结果请参照事件ANYLIVE_EVENT_PROBE_INFO
     *
     *     upSpeed::上传速度 kps  比如 我们测试码率10000kps 这时候网络状态时候好
 测试后会有结果返回
     *     downSpeed:: 下行速度
     *     TestTime::测试时间 单位为秒
     *     upSpeed,downSpeed任何一个为0 表示不对该项进行测速
     *
     *     VCS_CreateRoom()后 VCS_JoniRoom()之前测试  VCS_JoniRoom 后 VCS_Probe()测速将失效
     *     也就是测速和加入会议不可同时进行
     *
     * @param upSpeed
     * @param downSpeed
     * @param TestTime
     * @param mystreamId
     * @return
     */
-(void)VCS_Probe:(int)upSpeed downSpeed:(int)downSpeed TestTimes:(int)TestTime myStreamId:(int)myStreamId;

/*
 设置当前f设备方向
 */

-(void)VCS_SetCurrentDeviceOrientation:(NSInteger)UIDeviceOrientation;


//frameType 0 audio   1 video
-(NSInteger)VCS_PushStreamByUser:(const unsigned char*)StreamData bitslen:(int)bitslen stamp:(uint32_t)pts dts:(uint32_t)dts track:(int)track frameType:(int)frameType;



/**
 设置小流信息  VCS_CreateVideoOutput 之前设置
 */

-(void)VCS_SetMinStreamInfo:(int)height bitrate:(int)bitrate fps:(int)fps;

@property (nonatomic, weak) id<callbackdataDelegate> delegate;
@end










