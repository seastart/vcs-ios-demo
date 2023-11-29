//
//  SGMQTTSSLSecurityPolicyTransport.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 06.12.15.
//  Copyright © 2015-2017 Christoph Krey. All rights reserved.
//

#import "SGMQTTTransport.h"
#import "SGMQTTSSLSecurityPolicy.h"
#import "SGMQTTCFSocketTransport.h"

/** SGMQTTSSLSecurityPolicyTransport
 * implements an extension of the SGMQTTCFSocketTransport by replacing the OS's certificate chain evaluation
 */
@interface SGMQTTSSLSecurityPolicyTransport : SGMQTTCFSocketTransport

/**
 * The security policy used to evaluate server trust for secure connections.
 *
 * if your app using security model which require pinning SSL certificates to helps prevent man-in-the-middle attacks
 * and other vulnerabilities. you need to set securityPolicy to properly value(see SGMQTTSSLSecurityPolicy.h for more detail).
 *
 * NOTE: about self-signed server certificates:
 * if your server using Self-signed certificates to establish SSL/TLS connection, you need to set property:
 * SGMQTTSSLSecurityPolicy.allowInvalidCertificates=YES.
 */
@property (strong, nonatomic) SGMQTTSSLSecurityPolicy *securityPolicy;

@end
