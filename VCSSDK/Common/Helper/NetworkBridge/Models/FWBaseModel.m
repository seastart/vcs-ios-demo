//
//  FWBaseModel.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/28.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWBaseModel.h"

@implementation FWBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    NSError *error;
    self = [super initWithDictionary:dict error:&error];
    if (self) {
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    return YES;
}

@end
