//
//  FWInterfaces.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - VCSSDK Appid
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPID;
#pragma mark - VCSSDK AppKey
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKAPPKEY;
#pragma mark - VCSSDK Signature
FOUNDATION_EXTERN NSString *__nonnull const VCSSDKSIGNATURE;
#pragma mark - 密码HmacSHA1加密Key
FOUNDATION_EXTERN NSString *__nonnull const HmacSha1Key;
#pragma mark - Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const VCSAPPGROUP;

#pragma mark - API默认服务器
FOUNDATION_EXTERN NSString *__nonnull const DATADEFAULTAPI;
#pragma mark - 服务器本地化Key
FOUNDATION_EXTERN NSString *__nonnull const DATADEFAULTAPIKEY;
#pragma mark - API请求默认文件夹
FOUNDATION_EXTERN NSString *__nonnull const DATADAPIHEADER;

#pragma mark - 获取验证码
FOUNDATION_EXTERN NSString *__nonnull const FWUserCodeInfofacePart;
#pragma mark - 账号登录
FOUNDATION_EXTERN NSString *__nonnull const FWUserLoginInterfacePart;
#pragma mark - 账号注册
FOUNDATION_EXTERN NSString *__nonnull const FWUserRegisterInfofacePart;
#pragma mark - 重置密码
FOUNDATION_EXTERN NSString *__nonnull const FWUserResetPasswordInfofacePart;
#pragma mark - 进入会议室
FOUNDATION_EXTERN NSString *__nonnull const FWUserEnterRoomInfofacePart;
#pragma mark - 获取房间临时文件上传Token
FOUNDATION_EXTERN NSString *__nonnull const FWUserRoomtempTokenInfofacePart;
#pragma mark - 绑定ClientID
FOUNDATION_EXTERN NSString *__nonnull const FWUserBangClientInterfacePart;
#pragma mark - 上传聊天文件
FOUNDATION_EXTERN NSString *__nonnull const FWUserChatFileUploadInterfacePart;
#pragma mark - 锁定会议室
FOUNDATION_EXTERN NSString *__nonnull const FWUserRoomLockInterfacePart;

@interface FWInterfaces : NSObject

@end

NS_ASSUME_NONNULL_END
