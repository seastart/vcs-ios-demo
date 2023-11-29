//
//  VCSLoggerResult.h
//  VCSSDK
//
//  Created by SailorGa on 2022/10/19.
//

#import "VCSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSAuthTokenItem;

@interface VCSAuthToken : VCSBaseModel

/// 鉴权令牌对象
@property (nonatomic, strong) VCSAuthTokenItem *data;

@end

@interface VCSAuthTokenItem : VCSBaseModel

/// 有效时长
@property (nonatomic, assign) NSInteger refresh;
/// 鉴权令牌
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
