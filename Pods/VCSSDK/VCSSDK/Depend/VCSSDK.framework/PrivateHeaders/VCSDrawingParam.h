//
//  VCSDrawingParam.h
//  VCSSDK
//
//  Created by SailorGa on 2022/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSDrawingParam : NSObject

/// 钢笔按钮标题
@property (nonatomic, copy) NSString *penTitle;
/// 荧光笔按钮标题
@property (nonatomic, copy) NSString *highlighterTitle;
/// 橡皮擦按钮标题
@property (nonatomic, copy) NSString *eraserTitle;
/// 颜色按钮标题
@property (nonatomic, copy) NSString *colorTitle;
/// 清除按钮标题
@property (nonatomic, copy) NSString *clearTitle;
/// 图片按钮标题
@property (nonatomic, copy) NSString *pictureTitle;

@end

NS_ASSUME_NONNULL_END
