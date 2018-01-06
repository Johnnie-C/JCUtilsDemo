//
//  JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCUtils.h"
#import "Reachability.h"

@implementation JCUtils

#pragma mark - general
+ (NSString *)appVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSBundle *)frameworkBundle{
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        frameworkBundle = [NSBundle bundleForClass:[self class]];
    });
    return frameworkBundle;
}


#pragma mark - network
+(BOOL)hasConnectivity{
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return (networkStatus == NotReachable) ? NO : YES;
}

#pragma mark - device
+ (BOOL)isIPhone{
    return [[UIDevice currentDevice].model hasPrefix:@"iPhone"];
}

+ (BOOL)isIPad{
    return [[UIDevice currentDevice].model hasPrefix:@"iPad"];
}

+ (BOOL)isIPhoneX{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
    && ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
    && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0");
}

+ (CGFloat)safeMarginForIPhoneX{
    //TODO: get proper size programmatically
    return 30;
}

+ (BOOL)isPortrait{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait
    || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown;
}

+ (BOOL)isLandscape{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight
    || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft;
}

+ (BOOL)isLandscapeLeft{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft;
}

+ (BOOL)isLandscapeRight{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight;
}

+ (CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)statusBarHeight{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

#pragma mark - email
+ (void)sendEmailToEmailAddress:(NSString *)email subject:(NSString *)subject
{
    NSString *emailURLStr = [NSString stringWithFormat:@"mailto:%@?subject=%@", email, subject];
    emailURLStr = [emailURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *emailURL = [NSURL URLWithString:emailURLStr];
    [[UIApplication sharedApplication] openURL:emailURL];
}

#pragma mark - redirection
+ (void)redirectToSystemSettingsAuthentication{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
@end
