//
//  FWBaseModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseModel : JSONModel

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;

/// 重载父类init
/// @param dict dict 数据
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
