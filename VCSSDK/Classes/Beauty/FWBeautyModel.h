//
//  FWBeautyModel.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2021/9/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBeautyModel : NSObject

/// 视频处理类型(大类)
@property (nonatomic, assign) FWBeautyDefine type;
/// 美肤操作类型(子类)
@property (nonatomic, assign) FWBeautySkin param;
/// 显示标题
@property (nonatomic, copy) NSString *title;
/// 标题的Key
@property (nonatomic, copy) NSString *titleKey;

/// 强度取值
@property (nonatomic, assign) float value;
/// 强度默认值
@property (nonatomic, assign) float defaultValue;

/// 参数强度取值比例，即：强度最大值
@property (nonatomic, assign) float ratio;

/// 常规情况图片
@property (nonatomic, copy) NSString *normalImageStr;
/// 选中情况图片
@property (nonatomic, copy) NSString *selectedImageStr;

@end

NS_ASSUME_NONNULL_END
