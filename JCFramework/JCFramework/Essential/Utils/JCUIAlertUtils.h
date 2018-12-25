//
//  JCUIAlertUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const NSInteger ALERT_TAG_PHONE_CALL;

@interface UIAlertAction(JCUtils)
- (void)_jcSetTitleColor:(UIColor *)color;
@end

@interface JCUIAlertUtils : NSObject

//alert
+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content okBtnTitle:(NSString *)okBtnTitle okHandler:(void (^)(UIAlertAction *action))okHandler;
+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content
               okBtnTitle:(NSString *)okBtnTitle okHandler:(void (^)(UIAlertAction *action))okHandler
         inViewController:(UIViewController *)viewController;
+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler;
+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content image:(UIImage *)image
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler;
+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content image:(UIImage *)image
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
       inViewController:(UIViewController *)viewController;

//action sheet
+ (void)showActionSheetForActions:(NSArray<UIAlertAction *> *)actions;
+ (void)showActionSheetForActions:(NSArray<UIAlertAction *> *)actions
                 inViewController:(UIViewController *)viewController;

+ (void)showCannotLoadAlertView:(NSString *)name;
+ (void)showCallConfirmAlertWithNumber:(NSString *)number inViewController:(UIViewController *)parentViewController;

@end
