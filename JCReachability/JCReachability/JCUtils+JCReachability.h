//
//  JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#if __has_include("JCFramework.h")
#import "JCFramework.h"
#else
#import <JCFramework/JCFramework.h>
#endif


@interface JCUtils (JCReachability)

+ (BOOL)hasConnectivity;

@end

