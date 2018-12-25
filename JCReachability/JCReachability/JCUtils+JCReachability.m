//
//  JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCUtils+JCReachability.h"
#import "Reachability.h"

@implementation JCUtils (JCReachability)
    
+ (BOOL)hasConnectivity{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (networkStatus == NotReachable) ? NO : YES;
}
    
@end

