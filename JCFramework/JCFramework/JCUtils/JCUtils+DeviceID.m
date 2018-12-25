//
//  JCUtils+DeviceID.m
//  JCFramework
//
//  Created by Johnnie Cheng on 25/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCUtils+DeviceID.h"
#import <SAMKeychain/SAMKeychain.h>

@implementation JCUtils (DeviceID)

+ (NSString *)deviceUDID{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUDID = [SAMKeychain passwordForService:appName account:@"uuid"];
    if (strApplicationUDID == nil){
        strApplicationUDID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SAMKeychain setPassword:strApplicationUDID forService:appName account:@"uuid"];
    }
    
    return strApplicationUDID;
}

@end
