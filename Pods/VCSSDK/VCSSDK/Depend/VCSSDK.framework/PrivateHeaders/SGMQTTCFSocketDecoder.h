//
// SGMQTTCFSocketDecoder.h
// SGMQTTClient.framework
// 
// Copyright © 2013-2017, Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGMQTTCFSocketDecoderState) {
    SGMQTTCFSocketDecoderStateInitializing,
    SGMQTTCFSocketDecoderStateReady,
    SGMQTTCFSocketDecoderStateError
};

@class SGMQTTCFSocketDecoder;

@protocol SGMQTTCFSocketDecoderDelegate <NSObject>

- (void)decoder:(SGMQTTCFSocketDecoder *)sender didReceiveMessage:(NSData *)data;
- (void)decoderDidOpen:(SGMQTTCFSocketDecoder *)sender;
- (void)decoder:(SGMQTTCFSocketDecoder *)sender didFailWithError:(NSError *)error;
- (void)decoderdidClose:(SGMQTTCFSocketDecoder *)sender;

@end

@interface SGMQTTCFSocketDecoder : NSObject <NSStreamDelegate>

@property (nonatomic) SGMQTTCFSocketDecoderState state;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSInputStream *stream;
@property (weak, nonatomic ) id<SGMQTTCFSocketDecoderDelegate> delegate;

- (void)open;
- (void)close;

@end


