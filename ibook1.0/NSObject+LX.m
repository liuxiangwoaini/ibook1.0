//
//  NSObject+LX.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "NSObject+LX.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
//#import <SystemConfiguration/>
#import "Reachability.h"
//#import <sys>

# warning 网络监测怎么做，不会啊。。。。
@implementation NSObject (LX)
+ (BOOL) connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (NSString* )connectwithnum
{
    
        
        NSString* result;
        
        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
        
        switch ([r currentReachabilityStatus]) {
                
            case NotReachable:// 没有网络连接
                
                result=@"meiyouwang";
                
                break;
                
            case ReachableViaWWAN:// 使用3G网络
                
                result=@"3g";
                
                break;
                
            case ReachableViaWiFi:// 使用WiFi网络
                
                result=@"wifi";
                
                break;
                
        }
        
        return result;
        
    
    
}
@end
