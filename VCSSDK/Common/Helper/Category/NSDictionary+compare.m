//
//  NSDictionary+compare.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/8/14.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "NSDictionary+compare.h"

@implementation NSDictionary(compare)

- (NSComparisonResult)comparePower:(NSDictionary *)audioDic {
    
    NSNumber *number1 = [NSNumber numberWithInt:[[self objectForKey:@"power"] intValue]];
    NSNumber *number2 = [NSNumber numberWithInt:[[audioDic objectForKey:@"power"] intValue]];
    NSComparisonResult result = [number1 compare:number2];
    /// 降序
    return result == NSOrderedAscending;
}

@end
