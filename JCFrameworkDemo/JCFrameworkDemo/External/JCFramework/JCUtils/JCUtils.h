//
//  JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface JCUtils : NSObject

+ (NSString *)appVersion;
+ (NSBundle *)frameworkBundle;

+ (BOOL)hasConnectivity;


#pragma mark - device info
+ (BOOL)isIPad;
+ (BOOL)isIPhone;
+ (BOOL)isIPhoneX;
+ (CGFloat)safeMarginForIPhoneX;
+ (BOOL)isPortrait;
+ (BOOL)isLandscape;
+ (BOOL)isLandscapeLeft;
+ (BOOL)isLandscapeRight;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)statusBarHeight;

#pragma mark - email
+ (void)sendEmailToEmailAddress:(NSString *)email subject:(NSString *)subject;

#pragma mark - redirection
+ (void)redirectToSystemSettingsAuthentication;
@end
