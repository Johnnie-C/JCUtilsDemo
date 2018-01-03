//
//  JCUIAlertUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "JCUIAlertUtils.h"
#import "CRToast.h"

#import "JCUtils.h"
#import "UIFont+JCUtils.h"
#import "UIColor+JCUtils.h"


const NSInteger ALERT_TAG_PHONE_CALL = 102;

@implementation JCUIAlertUtils

#pragma mark - alert
+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content okHandler:(void (^)(UIAlertAction *action))okHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:okHandler];
    
    if ([okButton respondsToSelector:NSSelectorFromString(@"_titleTextColor")]) {
        [okButton setValue:[UIColor appMainColor] forKey:@"titleTextColor"];
    }
    
    [alert addAction:okButton];
    
    [[JCUIAlertUtils rootViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
            noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
{
    [JCUIAlertUtils showYesNoDialog:title content:content
                        yesBtnTitle:yesBtnTitle yesHandler:yesHandler
                         noBtnTitle:noBtnTitle noHandler:noHandler
                   inViewController:[JCUIAlertUtils rootViewController]];
}

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
       inViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:yesBtnTitle
                                style:UIAlertActionStyleDefault
                                handler:yesHandler];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:noBtnTitle
                               style:UIAlertActionStyleDefault
                               handler:noHandler];
    
    if ([yesButton respondsToSelector:NSSelectorFromString(@"_titleTextColor")]) {
        [yesButton setValue:[UIColor appMainColor] forKey:@"titleTextColor"];
    }
    
    if ([noButton respondsToSelector:NSSelectorFromString(@"_titleTextColor")]) {
        [noButton setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    }
    
    [alert addAction:yesButton];
    
    if(noBtnTitle.length){
        [alert addAction:noButton];
    }
    alert.preferredAction = yesButton;
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showCannotLoadAlertView:(NSString *)name{
    NSString *reasonString = [NSString stringWithFormat:@"Cannot load %@ without an active internet connection",name];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                   message:reasonString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    [alert addAction:okButton];
    
    [[JCUIAlertUtils rootViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showCallConfirmAlertWithNumber:(NSString *)number{
    if([JCUtils isIPhone]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Call"
                                                                       message:[NSString stringWithFormat:@"%@", number]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       NSString *num = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                                       NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", num]];
                                       [[UIApplication sharedApplication] openURL:phoneURL];
                                   }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                       handler:nil];
        
        [alert addAction:okButton];
        [alert addAction:cancelButton];
        
        
        [[JCUIAlertUtils rootViewController] presentViewController:alert animated:YES completion:nil];
    }
    else{
        [JCUIAlertUtils showConfirmDialog:@"Error" content:@"This device does not support for phone call." okHandler:nil];
    }
}

+ (UIViewController *)rootViewController{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

#pragma mark - toast
+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour
{
    [self toastWithMessage:message colour:colour completion:nil];
}


+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour completion:(void (^)(void))completion{
    NSDictionary *options = @{
                              kCRToastTextKey : message,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : colour,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTimeIntervalKey : @(2),
                              kCRToastFontKey : [UIFont fontWithSize:20],
                              kCRToastInteractionRespondersKey : @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                                   automaticallyDismiss:YES
                                                                                                                                  block:^(CRToastInteractionType interactionType){
                                                                                                                                      
                                                                                                                                  }]]
                              };
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:completion];
    
}

@end
