//
//  FWMacros.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#ifndef FWMacros_h
#define FWMacros_h

#pragma mark - 自定义DEBUG日志
#ifdef DEBUG
#define SGLOG(format,...) NSLog((@"[%@][%d] " format),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
/// #define SGLOG(str, args...) ((void)0)
#else
#define SGLOG(str, args...) ((void)0)
#endif

#pragma mark - 是否是iPad
#define isPad [[UIDevice currentDevice].model isEqualToString:@"iPad"]

#pragma mark - 是否是iPhone
#define isPhone [[UIDevice currentDevice].model isEqualToString:@"iPhone"]

#pragma mark - 设备是否为iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 设备是否为iPhoneXR
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 设备是否为iPhoneXS
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 设备是否为iPhoneXS Max
#define iPhoneXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 获取设备屏幕宽度/高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#pragma mark - 顶部状态栏高度
#define StatusBarHeight ((iPhoneX == YES || iPhoneXR == YES || iPhoneXS == YES || iPhoneXsMax == YES) ? 44.0 : 20.0)

#pragma mark - 顶部导航栏高度
#define NaviBarHeight ((iPhoneX == YES || iPhoneXR == YES || iPhoneXS == YES || iPhoneXsMax == YES) ? 88.0 : 64.0)

#pragma mark - 底部导航栏高度
#define TabBarHeight ((iPhoneX == YES || iPhoneXR == YES || iPhoneXS == YES || iPhoneXsMax == YES) ? 83.0 : 49.0)

#pragma mark - 底部安全距离高度
#define SafeBarHeight ((iPhoneX == YES || iPhoneXR == YES || iPhoneXS == YES || iPhoneXsMax == YES) ? 34.0 : 0.01)

#pragma mark - 设备标识
#define DeviceUUID [[UIDevice currentDevice].identifierForVendor UUIDString]

#pragma mark - 设备名称
#define DeviceName [UIDevice currentDevice].name

#pragma mark - App名字
#define BundleDisplayName [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleDisplayName"]

#pragma mark - App构建版本
#define BundleVersion [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleVersion"]

#pragma mark - App版本号
#define BundleShortVersion [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleShortVersionString"]

#pragma mark - 获取AppDelegate
#define KCurrentAppDelegate ((FWAppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark - 快速设置图片
#define kGetImage(imageName) [UIImage imageNamed:imageName]

#pragma mark - 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#pragma mark - 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

#pragma mark - 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

#pragma mark - Data是否为空
#define kDataIsEmpty(jsonData) ([jsonData isKindOfClass:[NSNull class]] || jsonData == nil || [jsonData length] < 1 ? YES : NO)

#pragma mark - 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - WeakSelf
#define WeakSelf() __weak typeof(self) weakSelf = self
#define StrongSelf(weakSelf) __strong typeof(self) strongSelf = weakSelf

#pragma mark - NSUserDefaults
#define kSGUserDefaults [NSUserDefaults standardUserDefaults]

#pragma mark - 主线程运行
#define RunOnMainThread(code) {dispatch_async(dispatch_get_main_queue(), ^{code;});}

#pragma mark - StringFromClass
#define kNibWithClass(className)  [UINib nibWithNibName:NSStringFromClass([className class]) bundle:nil]
#define kStringFromClass(className) NSStringFromClass([className class])

#pragma mark - 取色值相关的方法
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:1.f]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:(a)]

#define RGBOF(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define RGBA_OF(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                             blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a) [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(v & 0xFF))/255.0 \
                                            alpha:a]

#define RGBOF(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

#endif /* FWMacros_h */
