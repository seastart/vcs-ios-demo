//
//  VCSDrawingBoard.h
//  Draw
//
//  Created by seastart on 2020/7/31.
//  Copyright © 2020 seastart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCSDrawDataModel.h"

NS_ASSUME_NONNULL_BEGIN

// 绘制类型(0-99:绘制  100-199:编辑  200-299:附加)
enum ShapeType {
    ShapeText       = 200,  // 文字
    ShapeRubber     = 100,  // 橡皮
    ShapePen        = 0,    // 笔
    ShapeLine       = 1,    // 直线
    ShapeRect       = 2,    // 矩形
    ShapeEllipse    = 3,    // 椭圆
    ShapeArrow      = 4     // 箭头
};

@interface VCSDrawingBoard : UIView

// 画布数据
@property (nonatomic, strong) UIImage *__nullable image;

// 使用矢量数据生成图形
- (void)drawData:(std::vector<drawing::PathDataModel>&)datas;

// 使用矢量数据生成图形
- (void)drawData:(std::vector<drawing::PathDataModel>&)datas isHistory:(BOOL)isHistory;

// 清除
- (void)clearContent;

// 清除
- (void)clearContent:(const std::string&)userId;

// 保存画布到image
- (void)saveDrawToImage;

// 保存画布到image
- (void)saveDrawToImage:(const std::string&)userId;

@end

// 画笔对象
@interface Painter : NSObject

@property (nonatomic, strong) UIBezierPath* painter;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, assign) float penAlpha;
@property (nonatomic, assign) CGBlendMode blendMode;

// 是需要调整优先级
@property (nonatomic, assign) bool isPriority;

// 对象身份标记
@property (nonatomic, strong) NSString* key;

@end

NS_ASSUME_NONNULL_END
