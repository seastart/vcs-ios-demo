//
// SGMQTTCFSocketEncoder.h
// SGMQTTClient.framework
//
// Copyright © 2013-2017, Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGMQTTCFSocketEncoderState) {
    SGMQTTCFSocketEncoderStateInitializing,
    SGMQTTCFSocketEncoderStateReady,
    SGMQTTCFSocketEncoderStateError
};

@class SGMQTTCFSocketEncoder;

@protocol SGMQTTCFSocketEncoderDelegate <NSObject>

- (void)encoderDidOpen:(SGMQTTCFSocketEncoder *)sender;
- (void)encoder:(SGMQTTCFSocketEncoder *)sender didFailWithError:(NSError *)error;
- (void)encoderdidClose:(SGMQTTCFSocketEncoder *)sender;

@end

@interface SGMQTTCFSocketEncoder : NSObject <NSStreamDelegate>

@property (nonatomic) SGMQTTCFSocketEncoderState state;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSOutputStream *stream;
@property (weak, nonatomic ) id<SGMQTTCFSocketEncoderDelegate> delegate;

- (void)open;
- (void)close;
- (BOOL)send:(NSData *)data;

@end

