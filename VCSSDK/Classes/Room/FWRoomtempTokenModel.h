//
//  FWRoomtempTokenModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/6/23.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWRoomtempTokenDetailsModel;
@protocol FWRoomtempTokenDetailsModel
@end

@class FWRoomtempTokenFileinfoModel;
@protocol FWRoomtempTokenFileinfoModel
@end

@class FWRoomtempTokenItemModel;
@protocol FWRoomtempTokenItemModel
@end

@interface FWRoomtempTokenModel : FWBaseModel

@property (nonatomic, strong) FWRoomtempTokenDetailsModel *data;

@end

@interface FWRoomtempTokenDetailsModel : FWBaseModel

@property (nonatomic, strong) FWRoomtempTokenFileinfoModel *fileinfo;
/// 是否成功(YES-说明已经存在此图片直接使用fileinfo NO-说明没有该图片需要上传)
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) FWRoomtempTokenItemModel *token;

@end

#pragma mark - 房间临时文件上传文件信息
@interface FWRoomtempTokenFileinfoModel : FWBaseModel

/// 文件ID
@property (nonatomic, copy) NSString *id;
/// 文件所属用户ID
@property (nonatomic, copy) NSString *account_id;
/// 创建时间
@property (nonatomic, assign) NSInteger created_at;
/// 更新时间
@property (nonatomic, assign) NSInteger updated_at;
/// 过期时间
@property (nonatomic, assign) NSInteger expire_at;
/// 文件名称
@property (nonatomic, copy) NSString *name;
/// 文件大小
@property (nonatomic, assign) NSInteger size;
/// 文件地址
@property (nonatomic, copy) NSString *url;

@end

#pragma mark - 房间临时文件上传TokenModel
@interface FWRoomtempTokenItemModel : FWBaseModel

/// 用于上传文件的参数
@property (nonatomic, copy) NSString *AWSAccessKeyId;
/// 用于上传文件的参数
@property (nonatomic, copy) NSString *Policy;
/// 用于上传文件的参数
@property (nonatomic, copy) NSString *Signature;
/// 用于上传文件的参数
@property (nonatomic, copy) NSString *acl;
/// 用于上传文件的参数
@property (nonatomic, copy) NSString *key;
/// 用于上传文件的参数
@property (nonatomic, assign) NSInteger success_action_status;
/// 文件上传地址
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
