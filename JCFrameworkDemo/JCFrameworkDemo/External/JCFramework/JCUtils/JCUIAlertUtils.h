//
//  JCUIAlertUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const NSInteger ALERT_TAG_PHONE_CALL;

#define TOAST_MESSAGE_RED [UIColor colorWithRed:228.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0]
#define TOAST_MESSAGE_GREEN [UIColor colorWithRed:60.0/255.0 green:180.0/255.0 blue:120.0/255.0 alpha:1.0]
#define TOAST_MESSAGE_ORANGE [UIColor colorWithRed:250.0/255.0 green:178.0/255.0 blue:80.0/255.0 alpha:1.0]

@interface JCUIAlertUtils : NSObject

//toast
+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour;
+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour completion:(void (^)(void))completion;

//alert
+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content okHandler:(void (^)(UIAlertAction *action))okHandler;

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler;
+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
       inViewController:(UIViewController *)viewController;

+ (void)showCannotLoadAlertView:(NSString *)name;
+ (void)showCallConfirmAlertWithNumber:(NSString *)number;

@end

