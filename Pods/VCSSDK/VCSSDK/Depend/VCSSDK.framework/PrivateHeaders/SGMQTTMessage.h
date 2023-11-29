//
// SGMQTTMessage.h
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
@class SGMQTTProperties;

/**
 Enumeration of MQTT Quality of Service levels
 */
typedef NS_ENUM(UInt8, SGMQTTQosLevel) {
    SGMQTTQosLevelAtMostOnce = 0,
    SGMQTTQosLevelAtLeastOnce = 1,
    SGMQTTQosLevelExactlyOnce = 2
};

/**
 Enumeration of MQTT protocol version
 */
typedef NS_ENUM(UInt8, SGMQTTProtocolVersion) {
    SGMQTTProtocolVersion0 = 0,
    SGMQTTProtocolVersion31 = 3,
    SGMQTTProtocolVersion311 = 4,
    SGMQTTProtocolVersion50 = 5
};

typedef NS_ENUM(UInt8, SGMQTTCommandType) {
    SGMQTT_None = 0,
    SGMQTTConnect = 1,
    SGMQTTConnack = 2,
    SGMQTTPublish = 3,
    SGMQTTPuback = 4,
    SGMQTTPubrec = 5,
    SGMQTTPubrel = 6,
    SGMQTTPubcomp = 7,
    SGMQTTSubscribe = 8,
    SGMQTTSuback = 9,
    SGMQTTUnsubscribe = 10,
    SGMQTTUnsuback = 11,
    SGMQTTPingreq = 12,
    SGMQTTPingresp = 13,
    SGMQTTDisconnect = 14,
    SGMQTTAuth = 15
};

@interface SGMQTTMessage : NSObject

@property (nonatomic) SGMQTTCommandType type;
@property (nonatomic) SGMQTTQosLevel qos;
@property (nonatomic) BOOL retainFlag;
@property (nonatomic) BOOL dupFlag;
@property (nonatomic) UInt16 mid;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSNumber *returnCode;
@property (strong, nonatomic) NSNumber *connectAcknowledgeFlags;
@property (strong, nonatomic) SGMQTTProperties *properties;

/**
 Enumeration of MQTT return codes
 */

typedef NS_ENUM(NSUInteger, SGMQTTReturnCode) {
    SGMQTTAccepted = 0,
    SGMQTTRefusedUnacceptableProtocolVersion = 1,
    SGMQTTRefusedIdentiferRejected = 2,
    SGMQTTRefusedServerUnavailable = 3,
    SGMQTTRefusedBadUserNameOrPassword = 4,
    SGMQTTRefusedNotAuthorized = 5,

    SGMQTTSuccess = 0,
    SGMQTTDisconnectWithWillMessage = 4,
    SGMQTTNoSubscriptionExisted = 17,
    SGMQTTContinueAuthentication = 24,
    SGMQTTReAuthenticate = 25,
    SGMQTTUnspecifiedError = 128,
    SGMQTTMalformedPacket = 129,
    SGMQTTProtocolError = 130,
    SGMQTTImplementationSpecificError = 131,
    SGMQTTUnsupportedProtocolVersion = 132,
    SGMQTTClientIdentifierNotValid = 133,
    SGMQTTBadUserNameOrPassword = 134,
    SGMQTTNotAuthorized = 135,
    SGMQTTServerUnavailable = 136,
    SGMQTTServerBusy = 137,
    SGMQTTBanned = 138,
    SGMQTTServerShuttingDown = 139,
    SGMQTTBadAuthenticationMethod = 140,
    SGMQTTKeepAliveTimeout = 141,
    SGMQTTSessionTakenOver = 142,
    SGMQTTTopicFilterInvalid = 143,
    SGMQTTTopicNameInvalid = 144,
    SGMQTTPacketIdentifierInUse = 145,
    SGMQTTPacketIdentifierNotFound = 146,
    SGMQTTReceiveMaximumExceeded = 147,
    SGMQTTPacketTooLarge = 149,
    SGMQTTMessageRateTooHigh = 150,
    SGMQTTQuotaExceeded = 151,
    SGMQTTAdministrativeAction = 152,
    SGMQTTPayloadFormatInvalid = 153,
    SGMQTTRetainNotSupported = 154,
    SGMQTTQoSNotSupported = 155,
    SGMQTTUseAnotherServer = 156,
    SGMQTTServerMoved = 157,
    SGMQTTSharedSubscriptionNotSupported = 158,
    SGMQTTConnectionRateExceeded = 159,
    SGMQTTSubscriptionIdentifiersNotSupported = 161,
    SGMQTTWildcardSubscriptionNotSupported = 162
};

// factory methods
+ (SGMQTTMessage *)connectMessageWithClientId:(NSString*)clientId
                                   userName:(NSString*)userName
                                   password:(NSString*)password
                                  keepAlive:(NSInteger)keeplive
                               cleanSession:(BOOL)cleanSessionFlag
                                       will:(BOOL)will
                                  willTopic:(NSString*)willTopic
                                    willMsg:(NSData*)willData
                                    willQoS:(SGMQTTQosLevel)willQoS
                                 willRetain:(BOOL)willRetainFlag
                              protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                      sessionExpiryInterval:(NSNumber *)sessionExpiryInterval
                                 authMethod:(NSString *)authMethod
                                   authData:(NSData *)authData
                  requestProblemInformation:(NSNumber *)requestProblemInformation
                          willDelayInterval:(NSNumber *)willDelayInterval
                 requestResponseInformation:(NSNumber *)requestResponseInformation
                             receiveMaximum:(NSNumber *)receiveMaximum
                          topicAliasMaximum:(NSNumber *)topicAliasMaximum
                               userProperty:(NSDictionary <NSString *, NSString *> *)userProperty
                          maximumPacketSize:(NSNumber *)maximumPacketSize
;

+ (SGMQTTMessage *)pingreqMessage;

+ (SGMQTTMessage *)disconnectMessage:(SGMQTTProtocolVersion)protocolLevel
                        returnCode:(SGMQTTReturnCode)returnCode
             sessionExpiryInterval:(NSNumber *)sessionExpiryInterval
                      reasonString:(NSString *)reasonString
                      userProperty:(NSDictionary <NSString *, NSString *> *)userProperty;

+ (SGMQTTMessage *)subscribeMessageWithMessageId:(UInt16)msgId
                                        topics:(NSDictionary *)topics
                                 protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                        subscriptionIdentifier:(NSNumber *)subscriptionIdentifier;

+ (SGMQTTMessage *)unsubscribeMessageWithMessageId:(UInt16)msgId
                                          topics:(NSArray *)topics
                                   protocolLevel:(SGMQTTProtocolVersion)protocolLevel;

+ (SGMQTTMessage *)publishMessageWithData:(NSData*)payload
                                onTopic:(NSString*)topic
                                    qos:(SGMQTTQosLevel)qosLevel
                                  msgId:(UInt16)msgId
                             retainFlag:(BOOL)retain
                                dupFlag:(BOOL)dup
                          protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                 payloadFormatIndicator:(NSNumber *)payloadFormatIndicator
              publicationExpiryInterval:(NSNumber *)publicationExpiryInterval
                             topicAlias:(NSNumber *)topicAlias
                          responseTopic:(NSString *)responseTopic
                        correlationData:(NSData *)correlationData
                           userProperty:(NSDictionary <NSString *, NSString *> *)userProperty
                            contentType:(NSString *)contentType;

+ (SGMQTTMessage *)pubackMessageWithMessageId:(UInt16)msgId
                              protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                                 returnCode:(SGMQTTReturnCode)returnCode
                               reasonString:(NSString *)reasonString
                               userProperty:(NSDictionary <NSString *, NSString *> *)userProperty;

+ (SGMQTTMessage *)pubrecMessageWithMessageId:(UInt16)msgId
                              protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                                 returnCode:(SGMQTTReturnCode)returnCode
                               reasonString:(NSString *)reasonString
                               userProperty:(NSDictionary <NSString *, NSString *> *)userProperty;

+ (SGMQTTMessage *)pubrelMessageWithMessageId:(UInt16)msgId
                              protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                                 returnCode:(SGMQTTReturnCode)returnCode
                               reasonString:(NSString *)reasonString
                               userProperty:(NSDictionary <NSString *, NSString *> *)userProperty;

+ (SGMQTTMessage *)pubcompMessageWithMessageId:(UInt16)msgId
                               protocolLevel:(SGMQTTProtocolVersion)protocolLevel
                                  returnCode:(SGMQTTReturnCode)returnCode
                                reasonString:(NSString *)reasonString
                                userProperty:(NSDictionary <NSString *, NSString *> *)userProperty;

+ (SGMQTTMessage *)messageFromData:(NSData *)data protocolLevel:(SGMQTTProtocolVersion)protocolLevel;

// instance methods
- (instancetype)initWithType:(SGMQTTCommandType)type;
- (instancetype)initWithType:(SGMQTTCommandType)type
                        data:(NSData *)data;
- (instancetype)initWithType:(SGMQTTCommandType)type
                         qos:(SGMQTTQosLevel)qos
                        data:(NSData *)data;
- (instancetype)initWithType:(SGMQTTCommandType)type
                         qos:(SGMQTTQosLevel)qos
                  retainFlag:(BOOL)retainFlag
                     dupFlag:(BOOL)dupFlag
                        data:(NSData *)data;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *wireFormat;


@end

@interface NSMutableData (MQTT)
- (void)appendByte:(UInt8)byte;
- (void)appendUInt16BigEndian:(UInt16)val;
- (void)appendUInt32BigEndian:(UInt32)val;
- (void)appendVariableLength:(unsigned long)length;
- (void)appendMQTTString:(NSString *)string;
- (void)appendBinaryData:(NSData *)data;

@end
