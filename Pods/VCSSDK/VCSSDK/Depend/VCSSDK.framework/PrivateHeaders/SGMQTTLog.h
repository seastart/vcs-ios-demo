//
//  SGMQTTLog.h
//  SGMQTTClient
//
//  Created by Christoph Krey on 10.02.16.
//  Copyright © 2016-2017 Christoph Krey. All rights reserved.
//

#if __has_feature(modules)
    @import Foundation;
#else
    #import <Foundation/Foundation.h>
#endif

#ifdef LUMBERJACK

#define LOG_LEVEL_DEF SGLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

#else /* LUMBERJACK */

typedef NS_OPTIONS(NSUInteger, SGLogFlag){
    /**
     *  0...00001 SGLogFlagError
     */
    SGLogFlagError      = (1 << 0),

    /**
     *  0...00010 SGLogFlagWarning
     */
    SGLogFlagWarning    = (1 << 1),

    /**
     *  0...00100 SGLogFlagInfo
     */
    SGLogFlagInfo       = (1 << 2),

    /**
     *  0...01000 SGLogFlagDebug
     */
    SGLogFlagDebug      = (1 << 3),

    /**
     *  0...10000 SGLogFlagVerbose
     */
    SGLogFlagVerbose    = (1 << 4)
};


typedef NS_ENUM(NSUInteger, SGLogLevel){
SGLogLevelOff       = 0,

/**
 *  Error logs only
 */
SGLogLevelError     = (SGLogFlagError),

/**
 *  Error and warning logs
 */
SGLogLevelWarning   = (SGLogLevelError   | SGLogFlagWarning),

/**
 *  Error, warning and info logs
 */
SGLogLevelInfo      = (SGLogLevelWarning | SGLogFlagInfo),

/**
 *  Error, warning, info and debug logs
 */
SGLogLevelDebug     = (SGLogLevelInfo    | SGLogFlagDebug),

/**
 *  Error, warning, info, debug and verbose logs
 */
SGLogLevelVerbose   = (SGLogLevelDebug   | SGLogFlagVerbose),

/**
 *  All logs (1...11111)
 */
SGLogLevelAll       = NSUIntegerMax
};

#ifdef DEBUG

#define SGLogVerbose if (sgLogLevel & SGLogFlagVerbose) NSLog
#define SGLogDebug if (sgLogLevel & SGLogFlagDebug) NSLog
#define SGLogWarn if (sgLogLevel & SGLogFlagWarning) NSLog
#define SGLogInfo if (sgLogLevel & SGLogFlagInfo) NSLog
#define SGLogError if (sgLogLevel & SGLogFlagError) NSLog

#else

#define SGLogVerbose(...)
#define SGLogDebug(...)
#define SGLogWarn(...)
#define SGLogInfo(...)
#define SGLogError(...)

#endif /* DEBUG */
#endif /* LUMBERJACK */

extern SGLogLevel sgLogLevel;

/** SGMQTTLog lets you define the log level for SGMQTTClient
 *  independently of using CocoaLumberjack
 */
@interface SGMQTTLog: NSObject

/** setLogLevel controls the log level for SGMQTTClient
 *  @param logLevel as follows:
 *
 *  default for DEBUG builds is SGLogLevelVerbose
 *  default for RELEASE builds is SGLogLevelWarning
 *
 *  Available log levels:
 *  SGLogLevelAll
 *  SGLogLevelVerbose
 *  SGLogLevelDebug
 *  SGLogLevelInfo
 *  SGLogLevelWarning
 *  SGLogLevelError
 *  SGLogLevelOff
 */
+ (void)setLogLevel:(SGLogLevel)logLevel;

@end
