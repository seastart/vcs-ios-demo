//
// SGMQTTSSLSecurityPolicyDecoder.h
// SGMQTTClient.framework
// 
// Copyright © 2013-2017, Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGMQTTSSLSecurityPolicy.h"
#import "SGMQTTCFSocketDecoder.h"

@interface SGMQTTSSLSecurityPolicyDecoder : SGMQTTCFSocketDecoder

@property(strong, nonatomic) SGMQTTSSLSecurityPolicy *securityPolicy;
@property(strong, nonatomic) NSString *securityDomain;

@end


