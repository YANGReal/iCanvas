//
//  GLNetworkUtility.m
//  LingShiKong
//
//  Created by dimmy on 13-4-25.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import "GLNetworkUtility.h"
#import "Reachability.h"



@implementation GLNetworkUtility

+(BOOL)isCurrentWifi{
    
    Reachability* r = [Reachability reachabilityForLocalWiFi];
    NetworkStatus status = [r currentReachabilityStatus];
    if (status==ReachableViaWiFi) {
        return YES;//wifi可达
    }
    return NO;
}

+(BOOL)isNetAvaliable{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable;
}

//同步post请求

@end
