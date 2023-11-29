//
//  VCSNetworkConnectModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/11/8.
//

#import "VCSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSNetworkConnectModel : VCSBaseModel

/// 网络回环延迟
@property (nonatomic, assign) NSInteger delay;

/// 互联网连接情况(YES-正常 NO-异常)
@property (nonatomic, assign) BOOL internetConnect;
/// 流媒体服务器连接情况(YES-正常 NO-异常)
@property (nonatomic, assign) BOOL streamConnect;
/// 信令服务器连接情况(YES-正常 NO-异常)
@property (nonatomic, assign) BOOL signalingConnect;

@end

NS_ASSUME_NONNULL_END
