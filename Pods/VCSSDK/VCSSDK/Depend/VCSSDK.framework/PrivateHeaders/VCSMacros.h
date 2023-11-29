//
//  VCSMacros.h
//  VCSSDK
//
//  Created by SailorGa on 2020/5/11.
//

#ifndef VCSMacros_h
#define VCSMacros_h

#pragma mark - 自定义DEBUG日志
#define VCSLOG(format,...) NSLog((@"[VCSSDKLOG][%@][%d] " format),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
/// #define VCSLOG(str, args...) ((void)0)

#pragma mark - 设备标识
#define VCSDeviceIdentifier [[UIDevice currentDevice].identifierForVendor UUIDString]

#pragma mark - 获取设备屏幕宽度/高度
#define VCS_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define VCS_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#pragma mark - 字符串是否为空
#define VCSStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#pragma mark - Data是否为空
#define VCSDataIsEmpty(jsonData) ([jsonData isKindOfClass:[NSNull class]] || jsonData == nil || [jsonData length] < 1 ? YES : NO)

#pragma mark - 数组是否为空
#define VCSArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

#pragma mark - 字典是否为空
#define VCSDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

#pragma mark - WeakSelf
#define VCSWeakSelf() __weak typeof(self) weakSelf = self
#define VCSStrongSelf(weakSelf) __strong typeof(self) strongSelf = weakSelf

#pragma mark - 当前资源包bundle
#define VCSBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSSDK"]
#define VCSDrawingBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSDrawing"]
#define VCSNetCallBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSNetCall"]
#define VCSPushBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSPush"]
#define VCSAudioBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSAudio"]
#define VCSLoginBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSLogin"]
#define VCSBeautyBundleModule [NSBundle bundleForFramework:[self class] module:@"VCSBeauty"]

#pragma mark - 从当前资源包中读取图片
#define VCSImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSSDK"]
#define VCSDrawingImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSDrawing"]
#define VCSNetCallImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSNetCall"]
#define VCSPushImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSPush"]
#define VCSAudioImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSAudio"]
#define VCSLoginImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSLogin"]
#define VCSBeautyImage(image) [NSBundle imageName:image bundleStrForFramework:[self class] module:@"VCSBeauty"]

#pragma mark - 获取国际化语言字符串
#define VCSLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSBundleModule]
#define VCSDrawingLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSDrawingBundleModule]
#define VCSNetCallLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSNetCallBundleModule]
#define VCSPushLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSPushBundleModule]
#define VCSAudioLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSAudioBundleModule]
#define VCSLoginLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSLoginBundleModule]
#define VCSBeautyLocalizedString(keyStr) [[VCSLocalizedHelper sharedManager] localizedStringForKey:keyStr table:@"Localizable" resourceBundle:VCSBeautyBundleModule]

#pragma mark - StringFromClass
#define VCSStringFromClass(className) NSStringFromClass([className class])

#pragma mark - 取色值相关的方法
#define VCSRGB(r,g,b) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:1.f]

#define VCSRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:(a)]

#define VCSRGBOF(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define VCSRGBA_OF(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                             blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define VCSRGBAOF(v, a) [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(v & 0xFF))/255.0 \
                                            alpha:a]

#define VCSRGBOF(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

#pragma mark - 上传最大码率(整个推流的上限码率)
#define VCS_STREAM_MAXBITRATE 3000

#pragma mark - 呼叫服务重连最大次数
#define VCS_NETCALL_CONNECT 15

/// 网络监测上行标志
#define VCSNETWORKUPLOADSIGN @"upld::"
/// 网络监测下行标志
#define VCSNETWORKDOWNSIGN @"down::"
/// 网络监测完成标志
#define VCSNETWORKFINSHEDSIGN @"none"
/// 模拟房间号码
#define VCSNETWORKROOMNO 50505050
/// 互联网连接等待时间
#define VCSINTERNETCONNECTWAIT 5
/// 流媒体单次检测时长
#define VCSNETWORKDUATION 10

#pragma mark - Dispatch函数
/// 异步线程操作
static inline void VCSDispatchAscyncOnGloabalQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (block) {
            block();
        }
    });
}

/// 回归主线程操作
static inline void VCSDispatchAscyncOnMainQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

/// 延时操作
static inline void VCSDispatchAfter(int64_t time, void(^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)time), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

#endif /* VCSMacros_h */
