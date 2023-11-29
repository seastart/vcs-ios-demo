//
// SGMQTTSSLSecurityPolicyEncoder.h
// SGMQTTClient.framework
//
// Copyright © 2013-2017, Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGMQTTSSLSecurityPolicy.h"
#import "SGMQTTCFSocketEncoder.h"

@interface SGMQTTSSLSecurityPolicyEncoder : SGMQTTCFSocketEncoder

@property(strong, nonatomic) SGMQTTSSLSecurityPolicy *securityPolicy;
@property(strong, nonatomic) NSString *securityDomain;

@end

