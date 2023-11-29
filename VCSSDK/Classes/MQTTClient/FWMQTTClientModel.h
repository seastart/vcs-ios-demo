//
//  FWMQTTClientModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/3/31.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FWMQTTClientDetailsModel;
@protocol FWMQTTClientDetailsModel
@end

#pragma mark - 呼叫服务信息
@interface FWMQTTClientModel : FWBaseModel

@property (nonatomic, strong) FWMQTTClientDetailsModel *data;

@end

#pragma mark - 呼叫服务详情信息
@interface FWMQTTClientDetailsModel : FWBaseModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, assign) NSInteger updated_at;
@property (nonatomic, assign) NSInteger expire_at;
@property (nonatomic, assign) NSInteger size;

@end

NS_ASSUME_NONNULL_END
