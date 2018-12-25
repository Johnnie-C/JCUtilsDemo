//
//  JCUIAlertUtils+CRToast.h
//  JCFramework
//
//  Created by Johnnie Cheng on 25/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCUIAlertUtils.h"


@interface JCUIAlertUtils (JCCRToast)

+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour;
+ (void)toastWithMessage:(NSString *)message colour:(UIColor *)colour completion:(void (^)(void))completion;

@end





@interface UIColor (JCCRToast)

- (UIColor *)toastMessageRed;
- (UIColor *)toastMessageGreen;
- (UIColor *)toastMessageOrange;

@end

