//
//  JCAuthenticationHanlder.m
//
//  Created by Johnnie on 13/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "JCAuthenticationHanlder.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "JCNavigationController.h"

#import "UIColor+JCUtils.h"
#import "UINavigationBar+JCUtils.h"
#import "JCUIAlertUtils.h"
#import "JCUtils.h"

#import "SAMKeychain.h"

static JCAuthenticationHanlder *sharedInstance;
NSString *const KEY_AUTH_CONFIG = @"key_authConfig";
NSString *const SERVICE_PASSCODE = @"jc_password";
NSString *const KEY_TOUCH_ID_ENABLED = @"key_touchIDEnabled";
NSString *const KEY_PASSCODE_ENABLED = @"key_passcodeEnabled";
NSString *const ERROR_FORGOT_PASSCODE_CLCIKED = @"JCError_forgotPasscodeClicked";

@interface JCAuthenticationHanlder()
@property (nonatomic, strong) void (^completion)(BOOL success, NSString *errorMsg);
@end




@implementation JCAuthenticationHanlder

+ (JCAuthenticationHanlder *)sharedHelper{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [JCAuthenticationHanlder new];
        NSDictionary *authConfig = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTH_CONFIG];
        if(!authConfig){
            [sharedInstance deletePasscode];
            [sharedInstance enableTouchID:NO];
            [sharedInstance enablePasscode:NO];
        }
    });
    
    return sharedInstance;
}

    

+ (BOOL)isTouchIDSupported{
    if ([LAContext class]) {
        return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    return NO;
}

+ (BOOL)isFaceIDSupported{
    if (@available(iOS 11.0, *)) {
        LAContext *context = [[LAContext alloc] init];
        return context.biometryType == LABiometryTypeFaceID;
    }
    return NO;
}

- (BOOL)hasEnableLocalAuthentication{
    return [self hasEnableLocalAuthentication] || [self hasEnablePassocodeAuthentication];
}

- (BOOL)hasEnableTouchIDAuthentication{
    NSDictionary *authConfig = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTH_CONFIG];
    return [[authConfig objectForKey:KEY_TOUCH_ID_ENABLED] boolValue];
}

- (BOOL)hasEnablePassocodeAuthentication{
    NSDictionary *authConfig = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTH_CONFIG];
    return [[authConfig objectForKey:KEY_PASSCODE_ENABLED] boolValue];
}

- (BOOL)hasCreatePasscode{
    return [SAMKeychain passwordForService:SERVICE_PASSCODE account:KEY_AUTH_CONFIG].length;
}

- (void)enableTouchID:(BOOL)enalbed{
    NSDictionary *authConfig = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTH_CONFIG];
    NSMutableDictionary *authConfigMult = [authConfig mutableCopy];
    if(!authConfigMult){
        authConfigMult = [NSMutableDictionary dictionary];
    }
    [authConfigMult setValue:@(enalbed) forKey:KEY_TOUCH_ID_ENABLED];
    [[NSUserDefaults standardUserDefaults] setObject:authConfigMult forKey:KEY_AUTH_CONFIG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)enablePasscode:(BOOL)enalbed{
    NSDictionary *authConfig = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTH_CONFIG];
    NSMutableDictionary *authConfigMult = [authConfig mutableCopy];
    if(!authConfigMult){
        authConfigMult = [NSMutableDictionary dictionary];
    }
    [authConfigMult setValue:@(enalbed) forKey:KEY_PASSCODE_ENABLED];
    [[NSUserDefaults standardUserDefaults] setObject:authConfigMult forKey:KEY_AUTH_CONFIG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deletePasscode{
    [SAMKeychain deletePasswordForService:SERVICE_PASSCODE account:KEY_AUTH_CONFIG];
}

#pragma mark - TouchID
- (void)authenticateWithBiometricsWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSError *error))completion{
    [self authenticateWithTitle:title policy:LAPolicyDeviceOwnerAuthenticationWithBiometrics Completion:completion];
}

- (void)authenticateWithTitle:(NSString *)title policy:(LAPolicy)policy Completion:(void(^)(BOOL success, NSError *error))completion{
    LAContext *myContext = [[LAContext alloc] init];
    myContext.localizedFallbackTitle = @"";
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:policy error:&authError]) {
        [myContext evaluatePolicy:policy
                  localizedReason:title
                            reply:completion];
    }
    else{
        [JCUIAlertUtils showYesNoDialog:@""
                                content:@"Please set and enable TouchID in \"Settings\""
                            yesBtnTitle:@"Settings"
                             yesHandler:^(UIAlertAction *action) {
                                 [JCUtils redirectToSystemSettingsAuthentication];
                             }
                             noBtnTitle:@"Cancel"
                              noHandler:nil];
    }
}

#pragma mark - Passcode
- (void)createNewPasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion{
    _completion = completion;
    [self showPasscodeViewWithAction:PasscodeActionSet title:title];
}

- (void)authenticateWithPasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion{
    _completion = completion;
    [self showPasscodeViewWithAction:PasscodeActionEnter title:title];
}

- (void)changePasswordWithTitle:(NSString *)title completion:(void(^)(BOOL success, NSString *errorMsg))completion{
    _completion = completion;
    [self showPasscodeViewWithAction:PasscodeActionChange title:title];
}

- (void)showPasscodeViewWithAction:(PasscodeAction)action title:(NSString *)title{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:action];
    passcodeViewController.title = title;
    passcodeViewController.delegate = self;
    passcodeViewController.rightCancelColor = [UIColor navigationbarIconColor];
    
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC presentViewController:[[JCNavigationController alloc] initWithRootViewController:passcodeViewController] animated:YES completion:nil];
}


#pragma mark -- PAPasscodeViewControllerDelegate
- (BOOL)isPasscodeValid:(NSString *)passcode{
    return [passcode isEqualToString:[SAMKeychain passwordForService:SERVICE_PASSCODE account:KEY_AUTH_CONFIG]];
}

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller{
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    _completion = nil;
}

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller{
    [SAMKeychain setPassword:controller.passcode forService:SERVICE_PASSCODE account:KEY_AUTH_CONFIG];
    
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:^{
        if(_completion){
            _completion(YES, nil);
        }
        _completion = nil;
    }];
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller{
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:^{
        if(_completion){
            _completion(YES, nil);
        }
        _completion = nil;
    }];
}

- (void)PAPasscodeViewController:(PAPasscodeViewController *)controller didFailToEnterPasscode:(NSInteger)attempts{
    if(_completion){
        _completion(NO, @"Passcode not match");
    }
}

- (void)PAPasscodeViewControllerChangePasscodeError:(NSString *)errorMsg{
    if(_completion){
        _completion(NO, errorMsg);
    }
}

- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller{
    [SAMKeychain setPassword:controller.passcode forService:SERVICE_PASSCODE account:KEY_AUTH_CONFIG];
    
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:^{
        if(_completion){
            _completion(YES, nil);
        }
        _completion = nil;
    }];
}

- (void)PAPasscodeViewControllerOnForgotPasscodeClicked:(PAPasscodeViewController *)controller{
    [JCUIAlertUtils showYesNoDialog:@"Forgot Passcode"
                            content:@"Re-login to reset passcode?"
                        yesBtnTitle:@"Reset"
                         yesHandler:^(UIAlertAction *action) {
                             UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                             [rootVC dismissViewControllerAnimated:YES completion:^{
                                 if(_completion){
                                     _completion(NO, ERROR_FORGOT_PASSCODE_CLCIKED);
                                 }
                                 _completion = nil;
                             }];
                         }
                         noBtnTitle:@"Cancel"
                          noHandler:nil
                   inViewController:controller];
}


//don't care now
- (void)PAPasscodeViewControllerDidEnterAlternativePasscode:(PAPasscodeViewController *)controller{}




@end
