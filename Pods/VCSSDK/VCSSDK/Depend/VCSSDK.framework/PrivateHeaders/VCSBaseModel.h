//
//  VCSBaseModel.h
//  VCSSDK
//
//  Created by SailorGa on 2021/7/4.
//

#import "SGJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VCSBaseResult;

@interface VCSBaseModel : SGJSONModel

/// 请求结果
@property (nonatomic, strong) VCSBaseResult *ret;

/// 构建对象
/// - Parameter dict: 字典数据
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

@interface VCSBaseResult : SGJSONModel

/// 错误码
@property (nonatomic, assign) NSInteger code;
/// 错误信息
@property (nonatomic, copy) NSString *cn;

/// 构建对象
/// - Parameter dict: 字典数据
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
