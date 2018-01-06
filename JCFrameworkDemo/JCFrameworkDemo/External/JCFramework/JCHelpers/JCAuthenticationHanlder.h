//
//  JCAuthenticationHanlder.h
//
//  Created by Johnnie on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPasscodeViewController.h"

extern NSString *const ERROR_FORGOT_PASSCODE_CLCIKED;

@interface JCAuthenticationHanlder : NSObject<PAPasscodeViewControllerDelegate>

+ (JCAuthenticationHanlder *)sharedHelper;

+ (BOOL)isFaceIDSupported;
+ (BOOL)isTouchIDSupported;

- (BOOL)hasEnableLocalAuthentication;
- (BOOL)hasEnableTouchIDAuthentication;
- (BOOL)hasEnablePassocodeAuthentication;
- (BOOL)hasCreatePasscode;

- (void)enableTouchID:(BOOL)enalbed;
- (void)enablePasscode:(BOOL)enalbed;
- (void)deletePasscode;

#pragma mark - TouchID
- (void)authenticateWithBiometricsWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSError *error))completion;

#pragma mark - Passcode
- (void)createNewPasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion;
- (void)authenticateWithPasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion;
- (void)changePasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion;
@end
