//
//  VCSDeviceBridge.h
//  VCSSDK
//
//  Created by SailorGa on 2022/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSDeviceBridge : NSObject

#pragma mark - 获取应用版本号信息
/// 获取应用版本号信息
+ (NSString *)getAppVersion;

#pragma mark - 获取应用Build版本号信息
/// 获取应用Build版本号信息
+ (NSString *)getAppBuildVersion;

#pragma mark - 获取应用包名信息
/// 获取应用包名信息
+ (NSString *)getAppBundleId;

#pragma mark - 获取应用名称信息
/// 获取应用名称信息
+ (NSString *)getAppDisplayName;

#pragma mark - 获取设备品牌
/// 获取设备品牌
+ (NSString *)getDeviceBrand;

#pragma mark - 获取系统名称
/// 获取系统名称
+ (NSString *)getSystemName;

#pragma mark - 获取系统版本
/// 获取系统版本
+ (NSString *)getSystemVersion;

#pragma mark - 获取设备名称
/// 获取设备名称
+ (NSString *)getDeviceName;

#pragma mark - 获取CPU核心数
/// 获取CPU核心数
+ (NSString *)getCountOfCores;

#pragma mark - 获取CPU架构
/// 获取CPU架构
+ (NSString *)getCPUType;

#pragma mark - 获取设备总内存
/// 获取设备总内存
+ (NSString *)getTotalMemory;

#pragma mark - 获取设备当前语言
/// 获取设备当前语言
+ (NSString *)getPreferredLanguage;

#pragma mark - 获取本地时区的名称
/// 获取本地时区的名称
+ (NSString *)getTimeZoneName;

#pragma mark - 获取屏幕尺寸
/// 获取屏幕尺寸
+ (CGSize)getScreenSize;

#pragma mark - 获取屏幕刻度
/// 获取屏幕刻度
+ (CGFloat)getScreenScale;

#pragma mark - 获取设备型号
/// 获取设备型号
+ (NSString *)getDeviceType;

#pragma mark - 获取移动网络类型
/// 获取移动网络类型
+ (NSString *)getNetType;

#pragma mark - 获取VPN状态
/// 获取VPN状态
+ (BOOL)getVPNStatus;

#pragma mark - 利用当前时间生成文件名称
/// 利用当前时间生成文件名称
+ (NSString *)createFilenameUsingTime;

@end

NS_ASSUME_NONNULL_END
