//
//  VCSPassthroughModel.h
//  VCSSDK
//
//  Created by SailorGa on 2022/4/9.
//

#import "Register.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCSPassthroughModel : GPBMessage

/// 初始化透传消息对象
- (instancetype)init;

/// 初始化透传消息对象
/// @param notify 推送通知
- (instancetype)initWithNotify:(PushNotification *)notify;

/// 构建透传消息对象
/// @param notify 推送通知
+ (instancetype)initializeWithNotify:(PushNotification *)notify;

/// 发送者用户ID
@property (nonatomic, copy) NSString *senderId;
/// 发送者用户名
@property (nonatomic, copy) NSString *senderName;
/// 发送者昵称
@property (nonatomic, copy) NSString *senderNickname;
/// 发送者头像地址
@property (nonatomic, copy) NSString *senderPortrait;
/// 透传消息内容
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
