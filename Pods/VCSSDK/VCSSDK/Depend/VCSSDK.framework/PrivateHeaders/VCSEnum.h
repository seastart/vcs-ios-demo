//
//  VCSEnum.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 码流类型标识符
/**
 码流类型标识符
 
 - VCSStreamIdentifierSub: 子码流标识符
 - VCSStreamIdentifierMain: 主码流标识符
 - VCSStreamIdentifierScreen: 共享码流标识符
 */
typedef enum : NSInteger {
    
    VCSStreamIdentifierSub = 1,
    VCSStreamIdentifierMain = 2,
    VCSStreamIdentifierScreen = 4
} VCSStreamIdentifier;

#pragma mark - 音频编码模式
/**
 音频编码模式
 
 - VCSAudioEncodeStateAac: AAC编码
 - VCSAudioEncodeStateOpus: OPUS编码
 */
typedef enum : NSInteger {
    
    VCSAudioEncodeStateAac = 0,
    VCSAudioEncodeStateOpus = 0x5355504F
} VCSAudioEncodeState;

#pragma mark - Picker音视频类型
/**
 Picker音视频类型
 
 - VCSPickerStateClose: 关闭Picker
 - VCSPickerStateAudio: Picker音频流
 - VCSPickerStateVideo:  Picker视频流
 - VCSPickerStateAudioAndVideo: Picker音视频流
 - VCSPickerStateBesides: 除某个人Picker
 */
typedef enum : NSInteger {
    
    VCSPickerStateClose = 0,
    VCSPickerStateAudio = 1,
    VCSPickerStateVideo = 2,
    VCSPickerStateAudioAndVideo = 3,
    VCSPickerStateBesides = 0x2000
} VCSPickerState;

#pragma mark - 会议室对方链路状态
/**
 会议室对方链路状态
 
 - VCSXbitrateInceptStateNormal: 正常
 - VCSXbitrateInceptStatePoor: 较差
 - VCSXbitrateInceptStateBad:  很差
 - VCSXbitrateInceptStateVeryBad: 极差
 - VCSXbitrateInceptStateLose: 下行链路状态不存在
 */
typedef enum : NSInteger {
    
    VCSXbitrateInceptStateNormal = 0,
    VCSXbitrateInceptStatePoor = -1,
    VCSXbitrateInceptStateBad = -2,
    VCSXbitrateInceptStateVeryBad = -3,
    VCSXbitrateInceptStateLose = -4
} VCSXbitrateInceptState;

#pragma mark - 当前发送端码率变化状态
/**
 当前发送端码率变化状态
 
 - VCSXbitrateSendStateStart: 码率自适应开始工作
 - VCSXbitrateSendStateNormal: 码率恢复到最初设置
 - VCSXbitrateSendStateHalf:  码率变为原来的一半
 - VCSXbitrateSendStateQuarter: 码率变为原来的四分之一
 - VCSXbitrateSendStateVeryBad: 当前网络环境及其差劲情况
 */
typedef enum : NSInteger {
    
    VCSXbitrateSendStateStart = 1000,
    VCSXbitrateSendStateNormal = 0,
    VCSXbitrateSendStateHalf = -1,
    VCSXbitrateSendStateQuarter = -2,
    VCSXbitrateSendStateVeryBad = -3,
} VCSXbitrateSendState;

#pragma mark - 电子画板连接状态
/**
 电子画板连接状态
 
 - VCSDrawConnectStateNormal: 默认状态
 - VCSDrawConnectStateSucceed: 连接成功
 - VCSDrawConnectStateFail: 连接失败
 */
typedef enum : NSInteger {
    
    VCSDrawConnectStateNormal = 0,
    VCSDrawConnectStateSucceed = 1,
    VCSDrawConnectStateFail = 2,
} VCSDrawConnectState;

#pragma mark - 音频输出端口类型
/**
 音频输出端口类型
 
 - VCSOutputAudioPortStateUnknown: 无效(未知原因)
 - VCSOutputAudioPortStateSpeaker: 扬声器(免提模式)
 - VCSOutputAudioPortStateReceiver: 听筒(听筒模式)
 - VCSOutputAudioPortStateBluetooth: 蓝牙设备(蓝牙模式)
 - VCSOutputAudioPortStateHeadset: 有线耳机设备(有线耳机模式)
 */
typedef enum : NSInteger {
    
    VCSOutputAudioPortStateUnknown = 0,
    VCSOutputAudioPortStateSpeaker = 1,
    VCSOutputAudioPortStateReceiver = 2,
    VCSOutputAudioPortStateBluetooth = 3,
    VCSOutputAudioPortStateHeadset = 4
} VCSOutputAudioPortState;

#pragma mark - 网络延时抗抖动等级
/**
 网络延时抗抖动等级
 
 - VCSNetworkDelayShakeStateUltraShort: 超短(0) 单向延迟120ms左右 这种模式下没有丢包补偿机制 并且编码关闭了B帧 一般不建议实际使用
 - VCSNetworkDelayShakeStateShort: 短(1) 单向延迟200ms左右 单次丢包补偿 B帧为1 双向对讲环境下可以使用
 - VCSNetworkDelayShakeStateMedium: 中(2) 单向延迟350ms左右 两次丢包补偿 B帧为1 双向对讲环境下推荐使用
 - VCSNetworkDelayShakeStateLong: 长(3) 单向延迟600ms左右 三次丢包补偿 B帧为3 这种模式仅用于单向收看 双向对讲环境下不建议使用 该参数无法动态设置
 */
typedef enum : NSInteger {
    
    VCSNetworkDelayShakeStateUltraShort = 0,
    VCSNetworkDelayShakeStateShort = 1,
    VCSNetworkDelayShakeStateMedium = 2,
    VCSNetworkDelayShakeStateLong = 3
} VCSNetworkDelayShakeState;

#pragma mark - 下行网络档位等级
/**
 下行网络档位等级
 
 - VCSDownLevelStateInvalid: 无效
 - VCSDownLevelStateNormal: 正常
 - VCSDownLevelStatePoor: 较差
 - VCSDownLevelStateBad:  很差
 - VCSDownLevelStateVeryBad: 极差
 */
typedef enum : NSInteger {
    
    VCSDownLevelStateInvalid = -1,
    VCSDownLevelStateNormal = 0,
    VCSDownLevelStatePoor = 1,
    VCSDownLevelStateBad = 2,
    VCSDownLevelStateVeryBad = 3
} VCSDownLevelState;


#pragma mark - 事件命令类型
/**
 事件命令类型
 
 - VCSCommandEventStateAudio: 音频状态
 - VCSCommandEventStateVideo: 视频状态
 - VCSCommandEventStateRole: 角色状态
 - VCSCommandEventStateHandup: 举手状态
 - VCSCommandEventStateEnter:  成员进入
 - VCSCommandEventStateExit: 成员退出
 - VCSCommandEventStateBegin: 会议开始
 - VCSCommandEventStateEnded: 会议结束
 - VCSCommandEventStateInvite:  邀请参会
 - VCSCommandEventStatePassthrough:  消息透传
 - VCSCommandEventStateKickout: 被踢出房间
 - VCSCommandEventStateInitiativeExit: 主动退出房间
 */
typedef enum : NSInteger {
    
    VCSCommandEventStateAudio = 2000,
    VCSCommandEventStateVideo,
    VCSCommandEventStateRole,
    VCSCommandEventStateHandup,
    VCSCommandEventStateEnter,
    VCSCommandEventStateExit,
    VCSCommandEventStateBegin,
    VCSCommandEventStateEnded,
    VCSCommandEventStateInvite,
    VCSCommandEventStatePassthrough,
    VCSCommandEventStateKickout,
    VCSCommandEventStateInitiativeExit
} VCSCommandEventState;

@interface VCSEnum : NSObject

@end

NS_ASSUME_NONNULL_END
