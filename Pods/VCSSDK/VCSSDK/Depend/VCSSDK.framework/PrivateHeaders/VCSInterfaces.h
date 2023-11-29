//
//  VCSInterfaces.h
//  VCSSDK
//
//  Created by SailorGa on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 接口请求公共路径
FOUNDATION_EXTERN NSString *__nonnull const VCSREQUESTPATH;
#pragma mark - 存储上传鉴权令牌
FOUNDATION_EXTERN NSString *__nonnull const VCSLoggerUploadAuthTokenKey;
#pragma mark - 存储鉴权令牌时效
FOUNDATION_EXTERN NSString *__nonnull const VCSLoggerUploadAuthTokenRefresh;
#pragma mark - 日志上报鉴权令牌
FOUNDATION_EXTERN NSString *__nonnull const VCSLoggerUploadAuthToken;
#pragma mark - 行为日志上报
FOUNDATION_EXTERN NSString *__nonnull const VCSLoggerLogsUpload;
#pragma mark - 实时日志上报
FOUNDATION_EXTERN NSString *__nonnull const VCSLoggerMetricUpload;

#pragma mark - 呼叫服务接收订阅主题
FOUNDATION_EXTERN NSString *__nonnull const VCSRegReceiveTopic;
#pragma mark - 呼叫服务发送订阅主题
FOUNDATION_EXTERN NSString *__nonnull const VCSRegServerPublishTopic;

#pragma mark - 会控服务接收订阅主题
FOUNDATION_EXTERN NSString *__nonnull const VCSRoomReceiveTopic;
#pragma mark - 会控服务接收全员广播订阅主题
FOUNDATION_EXTERN NSString *__nonnull const VCSRoomBroadcastReceiveTopic;
#pragma mark - 会控服务发送订阅主题
FOUNDATION_EXTERN NSString *__nonnull const VCSRoomServerPublishTopic;

#pragma mark - 美颜预览卸载通知
FOUNDATION_EXTERN NSString *__nonnull const VCSBeautyPreviewUninstallNotification;

@interface VCSInterfaces : NSObject

@end

NS_ASSUME_NONNULL_END
