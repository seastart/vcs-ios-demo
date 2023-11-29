//
//  VCSNetworkConfig.h
//  VCSSDK
//
//  Created by SailorGa on 2021/11/1.
//

#import <Foundation/Foundation.h>
#import "VCSCommons.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSNetworkConfig : NSObject

/* ******** ⬇️ 登录用户信息(房间外部检测必填项) ⬇️ ******** */
/// 当前登录用户编号
@property (nonatomic, assign) int streamId;
/* ******** ⬆️ 登录用户信息(房间外部检测必填项) ⬆️ ******** */


/* ******** ⬇️ 流媒体服务信息(房间外部检测必填项) ⬇️ ******** */
/// 流媒体服务地址
@property (nonatomic, copy) NSString *streamHost;
/// 流媒体服务端口
@property (nonatomic, assign) int streamPort;
/* ******** ⬆️ 流媒体服务信息(房间外部检测必填项) ⬆️ ******** */


/* ******** ⬇️ 网络检测配置项(必填项,不设置采用默认值) ⬇️ ********* */
/// 上行码率，默认 2000kbps，设置为0时不对上行做检测
@property (nonatomic, assign) int upSpeed;
/// 下行码率，默认 2000kbps，设置为0时不对下行做检测
@property (nonatomic, assign) int downSpeed;
/// 测试时长，默认 30s
@property (nonatomic, assign) int duration;
/* ******** ⬆️ 网络检测配置项(必填项,不设置采用默认值) ⬆️ ******** */

/// 设备标识
@property (nonatomic, strong) NSString *deviceId;

@end

NS_ASSUME_NONNULL_END
