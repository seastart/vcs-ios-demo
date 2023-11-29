//
//  SGMQTTClient.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 13.01.14.
//  Copyright © 2013-2017 Christoph Krey. All rights reserved.
//

/**
 Include this file to use SGMQTTClient classes in your application
 
 @author Christoph Krey c@ckrey.de
 @see http://mqtt.org
 */

#import <Foundation/Foundation.h>

#import "SGMQTTSession.h"
#import "SGMQTTDecoder.h"
#import "SGMQTTSessionLegacy.h"
#import "SGMQTTProperties.h"
#import "SGMQTTMessage.h"
#import "SGMQTTTransport.h"
#import "SGMQTTCFSocketTransport.h"
#import "SGMQTTCoreDataPersistence.h"
#import "SGMQTTSSLSecurityPolicyTransport.h"
#import "SGMQTTLog.h"
#import "SGMQTTSessionManager.h"

//! Project version number for SGMQTTClient.
FOUNDATION_EXPORT double SGMQTTClientVersionNumber;

//! Project version string for SGMQTTClient&lt;.
FOUNDATION_EXPORT const unsigned char SGMQTTClientVersionString[];

