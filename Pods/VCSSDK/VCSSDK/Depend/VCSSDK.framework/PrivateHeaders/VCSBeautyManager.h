//
//  VCSBeautyManager.h
//  VCSSDK
//
//  Created by SailorGa on 2021/9/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 渲染填充模式
/**
 渲染填充模式

 - VCSDisplayViewContentModeScaleAspectFill: 等比例短边充满
 - VCSDisplayViewContentModeScaleToFill: 拉伸铺满
 - VCSDisplayViewContentModeScaleAspectFit: 等比例长边充满
*/
typedef NS_ENUM(NSInteger, VCSDisplayViewContentMode) {
    
    VCSDisplayViewContentModeScaleAspectFill = 0,
    VCSDisplayViewContentModeScaleToFill = 1,
    VCSDisplayViewContentModeScaleAspectFit = 2,
};

#pragma mark - 日志等级
/**
 日志等级

 - VCSBeautyLogLevelTrace: TRACE
 - VCSBeautyLogLevelDebug: DEBUG
 - VCSBeautyLogLevelInfo: INFO
 - VCSBeautyLogLevelWarn: WARN
 - VCSBeautyLogLevelError: ERROR
 - VCSBeautyLogLevelCritical: CRITICAL
 - VCSBeautyLogLevelOff: OFF
*/
typedef NS_ENUM(NSInteger, VCSBeautyLogLevel) {
    
    VCSBeautyLogLevelTrace = 0,
    VCSBeautyLogLevelDebug = 1,
    VCSBeautyLogLevelInfo = 2,
    VCSBeautyLogLevelWarn = 3,
    VCSBeautyLogLevelError = 4,
    VCSBeautyLogLevelCritical = 5,
    VCSBeautyLogLevelOff = 6,
};

@interface VCSBeautyManager : NSObject

#pragma mark - -------- 美颜服务可配置属性 ---------
#pragma mark 磨皮程度
/// 磨皮程度，取值范围 0.0-1.0，默认0.5
@property (nonatomic, assign) double blurLevel;
#pragma mark 美白程度
/// 美白程度，取值范围 0.0-1.0，默认值0.3
@property (nonatomic, assign) double whiteLevel;
#pragma mark 红润程度
/// 红润程度，取值范围 0.0-1.0，默认值0.3
@property (nonatomic, assign) double redLevel;
#pragma mark 锐化程度
/// 锐化程度，取值范围 0.0-1.0，默认0.3
@property (nonatomic, assign) double sharpen;
#pragma mark 设置滤镜
/// 设置滤镜，取值为一个字符串，默认值为 “origin” ，origin即为使用原图效果
@property (nonatomic, strong) NSString *filterName;
#pragma mark 滤镜程度
/// 滤镜程度，取值范围 0.0-1.0，默认值1.0
@property (nonatomic, assign) double filterLevel;


#pragma mark 服务是否启用
/// 服务是否启用
@property (nonatomic, assign, readonly) BOOL serviceEnabled;

#pragma mark 美颜模块是否启用
/// 美颜模块是否启用
@property (nonatomic, assign, readonly) BOOL beautyEnabled;

#pragma mark 预览模块是否启用
/// 预览模块是否启用
@property (nonatomic, assign, readonly) BOOL displayEnabled;


#pragma mark - -------- 美颜服务基础接口 ---------
#pragma mark 单例模式初始化美颜服务实例
/// 单例模式初始化美颜服务实例
+ (VCSBeautyManager *)sharedManager;

#pragma mark 获取美颜服务版本号
/// 获取录音服务版本号
- (NSString *)version;

#pragma mark 获取美颜服务版本信息
/// 获取录音服务版本信息
- (NSString *)getVersionInfo;

#pragma mark 销毁美颜服务资源
/// 销毁美颜服务资源
- (void)destroy;

#pragma mark - 初始化美颜服务
/// 初始化美颜服务
/// @param authData 密钥地址
/// @param authDataSize 密钥长度
/// @param logLevel 日志等级
- (void)setupRenderKit:(char *)authData authDataSize:(int)authDataSize logLevel:(VCSBeautyLogLevel)logLevel;

#pragma mark - 设置美颜状态
/// 设置美颜状态
/// @param enabled 开/关
- (void)onBeautySwitch:(BOOL)enabled;

#pragma mark - 渲染视频数据
/// 渲染视频数据
/// @param pixelBuffer 原数据
- (CVPixelBufferRef)renderWithInput:(CVPixelBufferRef)pixelBuffer;

#pragma mark - 装载美颜本地预览
/// 装载美颜本地预览
/// @param superView 父类视图
/// @param frame 预览布局
- (void)installLocalDisplayViewReady:(UIView *)superView frame:(CGRect)frame;

#pragma mark - 开启预览
/// 开启预览
- (void)startPreview;

#pragma mark - 停止预览
/// 停止预览
- (void)stopPreview;

#pragma mark - 修改采集分辨率
/// 修改采集分辨率
/// @param sessionPreset string constants
- (BOOL)changeSessionPreset:(AVCaptureSessionPreset)sessionPreset;

#pragma mark - 卸载美颜本地预览
/// 卸载美颜本地预览
- (void)uninstallLocalDisplay;

#pragma mark - 更新渲染填充模式
/// 更新渲染填充模式
/// @param contentMode 填充模式
- (void)renewDisplayWithContentMode:(VCSDisplayViewContentMode)contentMode;

#pragma mark - 更新渲染组件布局
/// 更新渲染组件布局
/// @param frame Frame
- (void)renewDisplayWithFrame:(CGRect)frame;

#pragma mark - 切换采集摄像头
/// 切换采集摄像头
- (void)changeCameraDevice;

@end

NS_ASSUME_NONNULL_END
