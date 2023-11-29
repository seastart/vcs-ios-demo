//
//  FWToolHelper.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWToolHelper.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@implementation FWToolHelper

#pragma mark - 初始化方法
/// 初始化方法
+ (FWToolHelper *)sharedManager {
    
    static FWToolHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWToolHelper alloc] init];
    });
    return manager;
}

#pragma mark - 获取服务器图片地址
/// 获取服务器完整图片地址
/// @param address 地址短连接
- (NSURL *)placeImg:(NSString *)address {
    
    if ([self replacingCharActer:address]) {
        return [NSURL URLWithString:[address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        return [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",DATADEFAULTAPI, address] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
}

#pragma mark - 判断是否有http/https子串
- (BOOL)replacingCharActer:(NSString *)portrait {
    
    NSRange httpRange = [portrait rangeOfString:@"http://"];
    NSRange httpsRange = [portrait rangeOfString:@"https://"];
    if(httpRange.length == 0 && httpsRange.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 获取当前时间戳
/// 获取当前时间戳
- (NSTimeInterval)getNowTimeInterval {
    
    return [[NSDate date] timeIntervalSince1970];
}

#pragma mark - 获取明天时间戳
/// 获取明天时间戳
- (NSTimeInterval)getTomorrowDay {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday |NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day] + 1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return [beginningOfWeek timeIntervalSince1970];
}

#pragma mark - 获取图片大小
/// 获取图片大小
/// @param image 原图
- (NSString *)calulateImageFileSize:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    double dataLength = [data length] * 1.0;
    /// return [NSString stringWithFormat:@"%.3f", dataLength];
    return [NSString stringWithFormat:@"%d", (int)dataLength];
}

#pragma mark - 获取图片Sha256之后的Base64加密串
/// 获取图片Sha256之后的Base64加密串
/// @param image 原图
- (NSString *)calulateImageSha256Base64File:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageSha256 = [self Sha256WithValue:imageData];
    return [self Base64String:imageSha256];
}

#pragma mark - Sha256方式加密的字符串
/// Sha256方式加密的字符串
/// @param value 加密数据
- (NSString *)Sha256WithValue:(NSData *)value {
    
    /// 定义长度为32个字节
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(value.bytes, (CC_LONG)value.length, digest);
    NSString *hash;
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    hash = output;
    return hash;
}

#pragma mark - Base64方式加密的字符串
/// Base64方式加密的字符串
/// @param value 加密数据
- (NSString *)Base64String:(NSString *)value {
    
    if (kStringIsEmpty(value)) {
        return @"";
    }
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark - HmacSHA1方式加密的字符串
/// HmacSHA1方式加密的字符串
/// @param key 加密Key
/// @param data 加密数据
- (NSString *)HmacSha1:(NSString *)key data:(NSString *)data {
    
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSString *hash;
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    hash = output;
    return hash;
}

#pragma mark - MD5方式加密的字符串
/// MD5方式加密的字符串
/// @param data 加密数据
- (NSString *)MD5:(NSString *)data {
    
    const char *cStr = [data UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

#pragma mark - 字典转Json字符串
/// 字典转Json字符串
/// @param dict 字典数据
- (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    /** 去掉字符串中的空格 */
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    /** 去掉字符串中的换行符 */
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

#pragma mark - 获取唯一标识符UUID
/// 获取唯一标识符UUID
- (NSString *)getUniqueIdentifier {
    
    /// 生成UUID并替换UUID分段连接符
    return [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
