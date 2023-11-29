//
//  FWEnum.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 用户获取验证码类型
/**
用户获取验证码类型

- FWUserCodeStateRegister: 注册
- FWUserCodeStateResetCode: 重置密码
*/
typedef enum : NSUInteger {
    FWUserCodeStateRegister = 1,
    FWUserCodeStateResetCode
} FWUserCodeState;

#pragma mark - 共享类型
/**
共享类型

- FWShareDrawingState: 共享白板
- FWSharePicturesState: 共享图片
*/
typedef enum : NSUInteger {
    FWShareDrawingState = 1,
    FWSharePicturesState
} FWShareState;

#pragma mark - 用户操作类型
/**
 用户操作类型

- FWUserOperateStateLogin: 登录
- FWUserOperateStateNetCall: 呼叫服务
- FWUserOperateStateMQTTNetCall: MQTT呼叫服务
- FWUserOperateStateInvite: 邀请服务
*/
typedef enum : NSUInteger {
    FWUserOperateStateLogin = 1,
    FWUserOperateStateNetCall,
    FWUserOperateStateMQTTNetCall,
    FWUserOperateStateInvite
} FWUserOperateState;

#pragma mark - 企业成员角色类型
/**
 企业成员角色类型

- FWCompanyMemberRoleTypeNormal: 普通成员
- FWCompanyMemberRoleTypeCreator: 创建者
- FWCompanyMemberRoleTypeAdmin: 管理员
*/
typedef enum : NSUInteger {
    FWCompanyMemberRoleTypeNormal = 0,
    FWCompanyMemberRoleTypeCreator,
    FWCompanyMemberRoleTypeAdmin
} FWCompanyMemberRoleType;

#pragma mark - 用户上传文件类型
/**
 用户上传文件类型

- FWUserUploadFileStatePicture: 图片类型
- FWUserUploadFileStateAudio: 音频类型
*/
typedef enum : NSUInteger {
    FWUserUploadFileStatePicture = 0,
    FWUserUploadFileStateAudio,
} FWUserUploadFileState;

#pragma mark - 视频处理类型
/**
 视频处理类型

 - FWBeautyDefineSkin: 美肤
 - FWBeautyDefineFilter: 滤镜
*/
typedef NS_ENUM(NSUInteger, FWBeautyDefine) {
    
    FWBeautyDefineSkin,
    FWBeautyDefineFilter
};

#pragma mark - 美肤操作类型
/**
 美肤操作类型

 - FWBeautySkinBlurLevel: 磨皮
 - FWBeautySkinColorLevel: 美白
 - FWBeautySkinRedLevel: 红润
 - FWBeautySkinSharpen: 锐化
 - FWBeautySkinMax: 美肤类型个数
*/
typedef NS_ENUM(NSUInteger, FWBeautySkin) {
    
    FWBeautySkinBlurLevel,
    FWBeautySkinColorLevel,
    FWBeautySkinRedLevel,
    FWBeautySkinSharpen,
    FWBeautySkinMax
};

@interface FWEnum : NSObject

@end

NS_ASSUME_NONNULL_END
