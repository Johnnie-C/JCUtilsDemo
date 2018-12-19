//
//  JCUIAlertUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCUIAlertUtils.h"
#import "CRToast.h"

#import "JCUIAlertController.h"
#import "JCUtils.h"
#import "UIFont+JCUtils.h"
#import "UIColor+JCUtils.h"


const NSInteger ALERT_TAG_PHONE_CALL = 102;

@implementation UIAlertAction(JCUtils)
- (void)_jcSetTitleColor:(UIColor *)color{
    if ([self respondsToSelector:NSSelectorFromString(@"_titleTextColor")]) {
        [self setValue:color forKey:@"titleTextColor"];
    }
}
@end


@implementation JCUIAlertUtils

#pragma mark - alert

+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content okBtnTitle:(NSString *)okBtnTitle okHandler:(void (^)(UIAlertAction *action))okHandler{
    [JCUIAlertUtils showConfirmDialog:title content:content okBtnTitle:okBtnTitle okHandler:okHandler inViewController:[JCUtils rootViewController]];
}

+ (void)showConfirmDialog:(NSString *)title content:(NSString *)content okBtnTitle:(NSString *)okBtnTitle okHandler:(void (^)(UIAlertAction *action))okHandler inViewController:(UIViewController *)viewController{
    if(!okBtnTitle.length){
        okBtnTitle = @"Ok";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:okBtnTitle
                               style:UIAlertActionStyleDefault
                               handler:okHandler];
    [okButton _jcSetTitleColor:[UIColor appMainColor]];
    [alert addAction:okButton];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
{
    [JCUIAlertUtils showYesNoDialog:title content:content image:nil
                        yesBtnTitle:yesBtnTitle yesHandler:yesHandler
                         noBtnTitle:noBtnTitle noHandler:noHandler
                   inViewController:[JCUtils rootViewController]];
}

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content image:(UIImage *)image
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
{
    [JCUIAlertUtils showYesNoDialog:title content:content image:image
                        yesBtnTitle:yesBtnTitle yesHandler:yesHandler
                         noBtnTitle:noBtnTitle noHandler:noHandler
                   inViewController:[JCUtils rootViewController]];
}

+ (void)showYesNoDialog:(NSString *)title content:(NSString *)content image:(UIImage *)image
            yesBtnTitle:(NSString *)yesBtnTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler
             noBtnTitle:(NSString *)noBtnTitle noHandler:(void (^)(UIAlertAction *action))noHandler
       inViewController:(UIViewController *)viewController
{
    JCUIAlertController *alert = [JCUIAlertController alertControllerWithTitle:title
                                                                       message:content
                                                                         image:image
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:yesBtnTitle
                                style:UIAlertActionStyleDefault
                                handler:yesHandler];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:noBtnTitle
                               style:UIAlertActionStyleDefault
                               handler:noHandler];
    
    [yesButton _jcSetTitleColor:[UIColor cancelRed]];
    [noButton _jcSetTitleColor:[UIColor okGrey]];
    
    if(noBtnTitle.length){
        [alert addAction:noButton];
    }
    [alert addAction:yesButton];
    
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
    
    [[JCUtils rootViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showCallConfirmAlertWithNumber:(NSString *)number inViewController:(UIViewController *)parentViewController{
    if([JCUtils isIPhone]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Call"
                                                                       message:[NSString stringWithFormat:@"%@", number]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       [JCUtils callNumber:number];
                                   }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:nil];
        
        [okButton _jcSetTitleColor:[UIColor appMainColor]];
        [cancelButton _jcSetTitleColor:[UIColor okGrey]];
        
        [alert addAction:okButton];
        [alert addAction:cancelButton];
        
        
        [parentViewController presentViewController:alert animated:YES completion:nil];
    }
    else{
        [JCUIAlertUtils showConfirmDialog:@"Error" content:@"This device does not support for phone call." okBtnTitle:@"Ok" okHandler:nil];
    }
}

#pragma mark - action sheet
+ (void)showActionSheetForActions:(NSArray<UIAlertAction *> *)actions
{
    [JCUIAlertUtils showActionSheetForActions:actions
                             inViewController:[JCUtils rootViewController]];
}

+ (void)showActionSheetForActions:(NSArray<UIAlertAction *> *)actions
                 inViewController:(UIViewController *)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for(UIAlertAction *action in actions){
        [action _jcSetTitleColor:action.style == UIAlertActionStyleCancel ? [UIColor cancelRed] : [UIColor blackColor]];
        [alert addAction:action];
    }
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - toast
+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour
{
    [self toastWithMessage:message colour:colour completion:nil];
}


+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour completion:(void (^)(void))completion{
    [CRToastManager dismissNotification:YES];
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
