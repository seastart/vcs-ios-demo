//
//  VCSLocalizedHelper.h
//  VCSSDK
//
//  Created by SailorGa on 2020/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSLocalizedHelper : NSObject

/**
 *  @brief 初始化方法
 *
 */
+ (VCSLocalizedHelper *)sharedManager;

/**
 获取本地语言字符串
 
 @param key key
 @param tableName tableName
 @param resourceBundle resourceBundle
 */
- (nullable NSString *)localizedStringForKey:(NSString * _Nonnull)key table:(nullable NSString *)tableName resourceBundle:(NSBundle * _Nonnull )resourceBundle;

@end

NS_ASSUME_NONNULL_END
