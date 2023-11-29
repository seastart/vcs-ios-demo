//
//  SGForegroundReconnection.h
//  SGMQTTClient
//
//  Created by Josip Cavar on 22/08/2017.
//  Copyright © 2017 Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE == 1

@class SGMQTTSessionManager;

@interface SGForegroundReconnection : NSObject

@property (weak, nonatomic) SGMQTTSessionManager *sessionManager;

- (instancetype)initWithSGMQTTSessionManager:(SGMQTTSessionManager *)manager;

@end

#endif
