//
//  ScreenRTCServerSocket.h
//  hkScreenShared
//
//  Created by rich rich on 28/5/2020.
//  Copyright © 2020 rich rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
//#import <pthread.h>

//#import "ScreenRTCConnect.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScreenRTCServerConnectProtocol;

@interface ScreenRTCServer:NSObject
//: ScreenRTCConnect

/**
 delegate
 */
@property(nonatomic , weak)id <ScreenRTCServerConnectProtocol> delegate;



//ModeType:0 encdoer ModeType:1 CSAMPLEBUFFER dedault encoder 需要和 client 保持统一模式
-(BOOL)initServerConnect:(int)ModeType; //初始化后方可创createServerConnect
/// 创建 server connect
- (BOOL)createServerConnect;

//
-(BOOL)destroyServerConnect;

-(BOOL )closeClientByCustomUser;
@end


@protocol ScreenRTCServerConnectProtocol <NSObject>

//非编码数据【NV12】
- (void)didProcessSampleBuffer:(CMSampleBufferRef)sampleBuffer stamp:(CMTime)pts;

//编码数据
- (void)didProcessEncoderData:(NSData*)sampleBuffer pts:(uint32_t)pts dts:(uint32_t)dts angle:(int)angle;

//Screen status  code [0:screen stop,1:screen start -1:screen connnect error]
-(void)didProcessStatus:(int)codes;
@end
NS_ASSUME_NONNULL_END
