//
//  FWToolHelper.h
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWToolHelper : NSObject

/// 初始化方法
+ (FWToolHelper *)sharedManager;

#pragma mark - 获取服务器图片地址
/// 获取服务器完整图片地址
/// @param address 地址短连接
- (NSURL *)placeImg:(NSString *)address;

/// 获取当前时间戳
- (NSTimeInterval)getNowTimeInterval;

/// 获取明天时间戳
- (NSTimeInterval)getTomorrowDay;

/// 获取图片大小
/// @param image 原图
- (NSString *)calulateImageFileSize:(UIImage *)image;

#pragma mark - 获取图片Sha256之后的Base64加密串
/// 获取图片Sha256之后的Base64加密串
/// @param image 原图
- (NSString *)calulateImageSha256Base64File:(UIImage *)image;

#pragma mark - Sha256方式加密的字符串
/// Sha256方式加密的字符串
/// @param value 加密数据
- (NSString *)Sha256WithValue:(NSData *)value;

#pragma mark - Base64方式加密的字符串
/// Base64方式加密的字符串
/// @param value 加密数据
- (NSString *)Base64String:(NSString *)value;

/// HmacSHA1方式加密的字符串
/// @param key 加密Key
/// @param data 加密数据
- (NSString *)HmacSha1:(NSString *)key data:(NSString *)data;

/// MD5方式加密的字符串
/// @param data 加密数据
- (NSString *)MD5:(NSString *)data;

/// 字典转Json字符串
/// @param dict 字典数据
- (NSString *)convertToJsonData:(NSDictionary *)dict;

/// 获取唯一标识符UUID
- (NSString *)getUniqueIdentifier;

@end

NS_ASSUME_NONNULL_END
