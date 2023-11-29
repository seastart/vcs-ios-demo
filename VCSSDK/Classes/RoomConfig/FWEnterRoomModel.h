//
//  FWEnterRoomModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"
#import "FWLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWEnterRoomDetailsModel;
@protocol FWEnterRoomDetailsModel
@end

@interface FWEnterRoomModel : FWBaseModel

@property (nonatomic, strong) FWEnterRoomDetailsModel *data;

@end

#pragma mark - 进入房间详情信息
@interface FWEnterRoomDetailsModel : FWBaseModel

/// 互动服务地址
@property (nonatomic, copy) NSString *meeting_host;
/// 互动服务端口
@property (nonatomic, assign) NSInteger meeting_port;
/// 互动服务ID
@property (nonatomic, copy) NSString *meeting_server_id;
/// WebRtc互动服务
@property (nonatomic, copy) NSString *meeting_ws_url;
/// 角色
@property (nonatomic, assign) NSInteger role;
/// SDK Number
@property (nonatomic, assign) NSInteger sdk_no;
/// SDK Session
@property (nonatomic, copy) NSString *session;
/// 流媒体地址
@property (nonatomic, copy) NSString *stream_host;
/// 流媒体端口
@property (nonatomic, assign) NSInteger stream_port;
/// WebRtc流媒体服务
@property (nonatomic, copy) NSString *stream_ws_url;
/// 房间标题
@property (nonatomic, copy) NSString *title;
/// 房间类型
@property (nonatomic, assign) NSInteger type;
/// 流媒体服务器ID
@property (nonatomic, copy) NSString *upload_id;
/// 电子白板地址
@property (nonatomic, copy) NSString *wb_host;
/// http websocket 端口
@property (nonatomic, assign) NSInteger ws_port;
/// https websocket 端口
@property (nonatomic, assign) NSInteger wss_port;

/// 账号信息
@property (nonatomic, strong) FWAccountModel *account;
/// 会议室信息
@property (nonatomic, strong) FWRoomModel *room;

@end

NS_ASSUME_NONNULL_END
