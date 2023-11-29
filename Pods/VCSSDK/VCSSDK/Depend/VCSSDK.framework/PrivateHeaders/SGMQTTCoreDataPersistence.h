//
//  SGMQTTCoreDataPersistence.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 22.03.15.
//  Copyright © 2015-2017 Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SGMQTTPersistence.h"

@interface SGMQTTCoreDataPersistence : NSObject <SGMQTTPersistence>

@end

@interface SGMQTTFlow : NSManagedObject <SGMQTTFlow>
@end

@interface SGMQTTCoreDataFlow : NSObject <SGMQTTFlow>
@end
