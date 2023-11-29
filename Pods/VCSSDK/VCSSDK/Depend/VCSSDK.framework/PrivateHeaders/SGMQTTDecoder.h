//
// SGMQTTDecoder.h
// SGMQTTClient.framework
// 
// Copyright © 2013-2017, Christoph Krey. All rights reserved.
//
// based on
//
// Copyright (c) 2011, 2013, 2lemetry LLC
// 
// All rights reserved. This program and the accompanying materials
// are made available under the terms of the Eclipse Public License v1.0
// which accompanies this distribution, and is available at
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contributors:
//    Kyle Roche - initial API and implementation and/or initial documentation
// 

#import <Foundation/Foundation.h>
#import "SGMQTTMessage.h"

typedef NS_ENUM(unsigned int, SGMQTTDecoderEvent) {
    SGMQTTDecoderEventProtocolError,
    SGMQTTDecoderEventConnectionClosed,
    SGMQTTDecoderEventConnectionError
};

typedef NS_ENUM(unsigned int, SGMQTTDecoderState) {
    SGMQTTDecoderStateInitializing,
    SGMQTTDecoderStateDecodingHeader,
    SGMQTTDecoderStateDecodingLength,
    SGMQTTDecoderStateDecodingData,
    SGMQTTDecoderStateConnectionClosed,
    SGMQTTDecoderStateConnectionError,
    SGMQTTDecoderStateProtocolError
};

@class SGMQTTDecoder;

@protocol SGMQTTDecoderDelegate <NSObject>

- (void)decoder:(SGMQTTDecoder *)sender didReceiveMessage:(NSData *)data;
- (void)decoder:(SGMQTTDecoder *)sender handleEvent:(SGMQTTDecoderEvent)eventCode error:(NSError *)error;

@end


@interface SGMQTTDecoder: NSObject <NSStreamDelegate>

@property (nonatomic) SGMQTTDecoderState state;
@property (strong, nonatomic) dispatch_queue_t queue;
@property (nonatomic) UInt32 length;
@property (nonatomic) UInt32 lengthMultiplier;
@property (nonatomic) int offset;
@property (strong, nonatomic) NSMutableData *dataBuffer;

@property (weak, nonatomic) id<SGMQTTDecoderDelegate> delegate;

- (void)open;
- (void)close;
- (void)decodeMessage:(NSData *)data;

@end


