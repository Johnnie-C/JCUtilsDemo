//
//  JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCReachability.h"

@implementation JCReachability
    
+ (BOOL)hasConnectivity{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (networkStatus == NotReachable) ? NO : YES;
}
    
@end

