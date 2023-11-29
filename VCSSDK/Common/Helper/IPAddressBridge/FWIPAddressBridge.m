//
//  FWIPAddressBridge.m
//  VCSSDK_Example
//
//  Created by SailorGa on 2020/4/29.
//  Copyright © 2020 SailorGa. All rights reserved.
//

#import "FWIPAddressBridge.h"
#import "FWIPAddressConfig.h"

#define IOS_CELLULAR @"pdp_ip0"
#define IOS_WIFI @"en0"
#define IOS_VPN @"utun0"
#define IP_ADDR_IPv4 @"ipv4"
#define IP_ADDR_IPv6 @"ipv6"

@implementation FWIPAddressBridge

#pragma mark - 初始化方法
/// 初始化方法
+ (FWIPAddressBridge *)sharedManager {
    
    static FWIPAddressBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FWIPAddressBridge alloc] init];
    });
    return manager;
}

#pragma mark - 获取具体的IP地址
/// 获取具体的IP地址
- (NSString *)currentIpAddress {
    
    return [self getIPAddress:YES];
}

#pragma mark - 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray = preferIPv4 ?
    @[IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv6] :
    @[IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4];
    
    NSDictionary *addresses = [self getIPAddresse];
    NSLog(@"++++++++当前设备网络IP地址信息: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
         address = addresses[key];
        if(address) {
            *stop = YES;
        }
     }];
    return address ? address : @"0.0.0.0";
}

#pragma mark - 获取所有相关IP信息
- (NSDictionary *)getIPAddresse {
    
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface -> ifa_next) {
            if (!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if (addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // 可用内存
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - 获取IP地址的详细信息
/// 获取IP地址的详细信息
- (void)currentIPAdressDetailInfo {
    
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    for (i = 0; i < MAXADDRS; ++i) {
        // 127.0.0.1
        static unsigned long localHost = 0x7F000001;
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0) {
            break;
        }
        if (theAddr == localHost) {
            continue;
        }
        
        NSLog(@"++++++++++Name: %s  MAC: %s  IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
    }
}

@end
