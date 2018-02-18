//
//  JCUIAlertController.h
//
//  Created by Johnnie on 10/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCUIAlertController : UIAlertController

+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message image:(nullable UIImage *)image preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
