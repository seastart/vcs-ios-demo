//
//  NSTimer+block.h
//  Draw
//
//  Created by seastart on 2020/8/8.
//  Copyright © 2020 seastart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (block)

+ (instancetype)repeatWithInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
