//
//  SGMQTTPersistence.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 22.03.15.
//  Copyright © 2015-2017 Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGMQTTMessage.h"

static BOOL const MQTT_PERSISTENT = NO;
static NSInteger const MQTT_MAX_SIZE = 64 * 1024 * 1024;
static NSInteger const MQTT_MAX_WINDOW_SIZE = 16;
static NSInteger const MQTT_MAX_MESSAGES = 1024;

/** SGMQTTFlow is an abstraction of the entity to be stored for persistence */
 
@protocol SGMQTTFlow
/** The clientID of the flow element */
@property (strong, nonatomic) NSString *clientId;

/** The flag indicating incoming or outgoing flow element */
@property (strong, nonatomic) NSNumber *incomingFlag;

/** The flag indicating if the flow element is retained*/
@property (strong, nonatomic) NSNumber *retainedFlag;

/** The SGMQTTCommandType of the flow element, might be SGMQTT_None for offline queueing */
@property (strong, nonatomic) NSNumber *commandType;

/** The SGMQTTQosLevel of the flow element */
@property (strong, nonatomic) NSNumber *qosLevel;

/** The messageId of the flow element */
@property (strong, nonatomic) NSNumber *messageId;

/** The topic of the flow element */
@property (strong, nonatomic) NSString *topic;

/** The data of the flow element */
@property (strong, nonatomic) NSData *data;

/** The deadline of the flow elelment before (re)trying transmission */
@property (strong, nonatomic) NSDate *deadline;

@end

/** The SGMQTTPersistence protocol is an abstraction of persistence classes for SGMQTTSession */

@protocol SGMQTTPersistence

/** The maximum Window Size for outgoing inflight messages per clientID. Defaults to 16 */
@property (nonatomic) NSUInteger maxWindowSize;

/** The maximum number of messages kept per clientID and direction. Defaults to 1024 */
@property (nonatomic) NSUInteger maxMessages;

/** Indicates if the persistence implementation should make the information permannent. Defaults to NO */
@property (nonatomic) BOOL persistent;

/** The maximum size of the storage used for persistence in total in bytes. Defaults to 1024*1024 bytes */
@property (nonatomic) NSUInteger maxSize;

/** The current Window Size for outgoing inflight messages per clientID.
 * @param clientId identifying the session
 * @return the current size of the outgoing inflight window
 */
- (NSUInteger)windowSize:(NSString *)clientId;

/** Stores one new message
 * @param clientId identifying the session
 * @param topic the topic of the message
 * @param data the message's data
 * @param retainFlag the retain flag of the message
 * @param qos the quality of service of the message
 * @param msgId the id of the message or zero for qos zero
 * @param incomingFlag the direction of the message
 * @param commandType the command of the message
 * @param deadline the deadline of the message for repetitions
 * @return the created SGMQTTFlow element or nil if the maxWindowSize has been exceeded
 */
- (id<SGMQTTFlow>)storeMessageForClientId:(NSString *)clientId
                                  topic:(NSString *)topic
                                   data:(NSData *)data
                             retainFlag:(BOOL)retainFlag
                                    qos:(SGMQTTQosLevel)qos
                                  msgId:(UInt16)msgId
                           incomingFlag:(BOOL)incomingFlag
                            commandType:(UInt8)commandType
                               deadline:(NSDate *)deadline;

/** Deletes an SGMQTTFlow element
 * @param flow the SGMQTTFlow to delete
 */
- (void)deleteFlow:(id<SGMQTTFlow>)flow;

/** Deletes all SGMQTTFlow elements of a clientId
 * @param clientId the client Id identifying all SGMQTTFlows to be deleted
 */
- (void)deleteAllFlowsForClientId:(NSString *)clientId;

/** Retrieves all SGMQTTFlow elements of a clientId and direction
 * @param clientId whos SGMQTTFlows should be retrieved
 * @param incomingFlag specifies the wether incoming or outgoing flows should be retrieved
 * @return an NSArray of the retrieved SGMQTTFlow elements
 */
- (NSArray *)allFlowsforClientId:(NSString *)clientId
                    incomingFlag:(BOOL)incomingFlag;

/** Retrieves an SGMQTTFlow element
 * @param clientId to which the SGMQTTFlow belongs to
 * @param incomingFlag specifies the direction of the flow
 * @param messageId specifies the message Id of the flow
 * @return the retrieved SGMQTTFlow element or nil if the elememt was not found
 */
- (id<SGMQTTFlow>)flowforClientId:(NSString *)clientId
                   incomingFlag:(BOOL)incomingFlag
                      messageId:(UInt16)messageId;

/** sync is called to allow the SGMQTTPersistence implemetation to save data permanently */
- (void)sync;

@end
