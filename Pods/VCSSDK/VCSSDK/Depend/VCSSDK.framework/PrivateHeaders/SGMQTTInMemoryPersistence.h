//
//  SGMQTTInMemoryPersistence.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 22.03.15.
//  Copyright © 2015-2017 Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGMQTTPersistence.h"

@interface SGMQTTInMemoryPersistence : NSObject <SGMQTTPersistence>
@end

@interface SGMQTTInMemoryFlow : NSObject <SGMQTTFlow>
@end
