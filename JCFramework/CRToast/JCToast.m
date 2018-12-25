//
//  JCToast.m
//  JCFramework
//
//  Created by Johnnie Cheng on 25/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCToast.h"
#import "CRToast.h"
#import "UIFont+JCUtils.h"


@implementation JCToast

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





@implementation UIColor (JCCRToast)

- (UIColor *)toastMessageRed{
    return [UIColor colorWithRed:228.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0];
}

- (UIColor *)toastMessageGreen{
    return [UIColor colorWithRed:60.0/255.0 green:180.0/255.0 blue:120.0/255.0 alpha:1.0];
}

- (UIColor *)toastMessageOrange{
    return [UIColor colorWithRed:250.0/255.0 green:178.0/255.0 blue:80.0/255.0 alpha:1.0];
}

@end
