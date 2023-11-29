//
//  VCSLoggerNetwork.h
//  VCSSDK
//
//  Created by SailorGa on 2022/10/13.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 网络连接状态
/**
 网络连接状态
 
 - VCSLoggerNetworkStatusUnknown: 未知
 - VCSLoggerNetworkStatusNotReachable: 无网络连接
 - VCSLoggerNetworkStatusReachableViaWWAN: 移动网络
 - VCSLoggerNetworkStatusReachableViaWiFi: Wi-Fi网络
 */
typedef enum : NSInteger {
    
    VCSLoggerNetworkStatusUnknown = -1,
    VCSLoggerNetworkStatusNotReachable = 0,
    VCSLoggerNetworkStatusReachableViaWWAN = 1,
    VCSLoggerNetworkStatusReachableViaWiFi = 2,
} VCSLoggerNetworkStatus;

FOUNDATION_EXPORT NSString * const VCSLoggerNetworkDidChangeNotification;
FOUNDATION_EXPORT NSString * const VCSLoggerNetworkNotificationStatusItem;

typedef void (^VCSLoggerNetworkStatusBlock)(VCSLoggerNetworkStatus status);

@interface VCSLoggerNetwork : NSObject

/// The current network reachability status.
@property (readonly, nonatomic, assign) VCSLoggerNetworkStatus networkStatus;

/// Whether or not the network is currently reachable.
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/// Whether or not the network is currently reachable via WWAN.
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/// Whether or not the network is currently reachable via WiFi.
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/// Returns the shared network reachability manager.
+ (instancetype)sharedManager;

/// Creates and returns a network reachability manager with the default socket address.
/// @return An initialized network reachability manager, actively monitoring the default socket address.
+ (instancetype)manager;

/// Creates and returns a network reachability manager for the socket address.
/// @param address The socket address (`sockaddr_in6`) used to evaluate network reachability.
/// @return An initialized network reachability manager, actively monitoring the specified socket address.
+ (instancetype)managerForAddress:(const void *)address;

/// Initializes an instance of a network reachability manager from the specified reachability object.
/// @param reachability The reachability object to monitor.
/// @return An initialized network reachability manager, actively monitoring the specified reachability.
- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER;

/// Unavailable initializer
+ (instancetype)new NS_UNAVAILABLE;

/// Unavailable initializer
- (instancetype)init NS_UNAVAILABLE;

/// Starts monitoring for changes in network reachability status.
/// @param changeBlock  A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`.
- (void)startMonitoring:(VCSLoggerNetworkStatusBlock)changeBlock;

/// Stops monitoring for changes in network reachability status.
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
