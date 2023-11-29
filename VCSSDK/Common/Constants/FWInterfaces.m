//
//  FWInterfaces.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWInterfaces.h"

#pragma mark - 密码HmacSHA1加密Key
NSString * const HmacSha1Key = @"0a6430bcb7084269817813a06e905979";
#pragma mark - Application Group Identifier
NSString * const VCSAPPGROUP = @"group.cn.seastart.vcsdemo";

#pragma mark - API默认服务器
/// NSString * const DATADEFAULTAPI = @"http://47.96.254.4";
NSString * const DATADEFAULTAPI = @"http://vcs.anyconf.cn:5000";
/// NSString * const DATADEFAULTAPI = @"http://47.99.169.94:5000";
/// NSString * const DATADEFAULTAPI = @"http://118.31.187.21";
/// NSString * const DATADEFAULTAPI = @"http://101.37.17.185";
/// NSString * const DATADEFAULTAPI = @"http://ezm.ys7.com";
/// NSString * const DATADEFAULTAPI = @"https://pb.swmeeting.cn";
#pragma mark - 服务器本地化Key
NSString * const DATADEFAULTAPIKEY = @"cn.seastart.vcssdk.sailorga.user";
#pragma mark - API请求默认文件夹
NSString * const DATADAPIHEADER = @"/vcs/";

#pragma mark - 获取验证码
NSString * const FWUserCodeInfofacePart = @"account/vcode";
#pragma mark - 账号登录
NSString * const FWUserLoginInterfacePart = @"account/login";
#pragma mark - 账号注册
NSString * const FWUserRegisterInfofacePart = @"account/register";
#pragma mark - 重置密码
NSString * const FWUserResetPasswordInfofacePart = @"account/reset-password";
#pragma mark - 进入会议室
NSString * const FWUserEnterRoomInfofacePart = @"room/enter";
#pragma mark - 获取房间临时文件上传Token
NSString * const FWUserRoomtempTokenInfofacePart = @"file/add";
#pragma mark - 绑定ClientID
NSString * const FWUserBangClientInterfacePart = @"account/set-pushid";
#pragma mark - 上传聊天文件
NSString * const FWUserChatFileUploadInterfacePart = @"chat/upload";
#pragma mark - 锁定会议室
NSString * const FWUserRoomLockInterfacePart = @"room/lock";

@implementation FWInterfaces

@end
