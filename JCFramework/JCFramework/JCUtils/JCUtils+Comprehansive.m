//
//  JCUtils+Comprehansive.m
//  JCFramework
//
//  Created by Johnnie Cheng on 25/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCUtils+Comprehansive.h"
#import <SAMKeychain/SAMKeychain.h>
#import "JCUIAlertUtils.h"

@implementation JCUtils (Comprehansive)

+ (NSString *)deviceUDID{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUDID = [SAMKeychain passwordForService:appName account:@"uuid"];
    if (strApplicationUDID == nil){
        strApplicationUDID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SAMKeychain setPassword:strApplicationUDID forService:appName account:@"uuid"];
    }
    
    return strApplicationUDID;
}

#pragma mark - share
+ (void)sendEmailToEmailAddress:(NSString *)email subject:(NSString *)subject{
    NSString *emailURLStr = [NSString stringWithFormat:@"mailto:%@?subject=%@", email, subject];
    emailURLStr = [emailURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *emailURL = [NSURL URLWithString:emailURLStr];
    [[UIApplication sharedApplication] openURL:emailURL];
}

+ (void)callNumber:(NSString *)number{
    if([JCUtils isIPhone]){
        NSString *num = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", num]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else{
        [JCUIAlertUtils showConfirmDialog:@"Error" content:@"This device does not support for phone call." okBtnTitle:@"Ok" okHandler:nil];
    }
    
}
@end
