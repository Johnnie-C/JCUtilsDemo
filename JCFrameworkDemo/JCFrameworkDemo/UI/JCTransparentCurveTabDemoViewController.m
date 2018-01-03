//
//  JCTransparentCurveTabDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 2/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCTransparentCurveTabDemoViewController.h"
#import "JCHeaderTabView.h"

#import "JCAuthenticationHanlder.h"
#import "JCUIAlertUtils.h"

@interface JCTransparentCurveTabDemoViewController ()<JCHeaderTabViewDelegate>

@property (weak, nonatomic) IBOutlet JCHeaderTabView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAuth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_btnAuthHeight;

@end





@implementation JCTransparentCurveTabDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        //important!!
        //to restore tab after rotato
        [_headerView selectTabAtIndex:_headerView.selectedIndex animated:NO];
    }];
}

- (void)setupView{
    [self setupNavBar];
    [self setupTabView];
}

- (void)setupNavBar{
    self.title = @"Transparent tab demo";
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
}

- (void)updateNavRighButton{
    if(!_headerView.selectedIndex){
        //left tab
        [self setRightBarButtonTypes:@[@(RightBarButtonTypeNone)]];
    }
    else{
        //right tab
        [self setRightBarButtonTypes:@[@([[JCAuthenticationHanlder sharedHelper] hasCreatePasscode] ? RightBarButtonTypeChange : RightBarButtonTypeAdd)]];
    }
}

- (void)hideAuthButtonWithCompletion:(void (^)(BOOL finished))completion{
    _const_btnAuthHeight.constant = 0;
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:completion];
}

- (void)showAuthButtonWithCompletion:(void (^)(BOOL finished))completion{
    _const_btnAuthHeight.constant = 50;
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:completion];
}

#pragma mark - action
- (IBAction)onBtnAuthClicked:(id)sender {
    if(!_headerView.selectedIndex){
        //left
        [self showBiometricsAuthentication];
    }
    else{
        //right
        [self showPasscodeAuthentication];
    }
}

#pragma mark - JCHeaderTabViewDelegate
- (void)setupTabView{
    _headerView.delegate = self;
    [self onTabSelected:0];
}

- (void)onTabSelected:(NSInteger)index{
    [_btnAuth setTitle:index ? @"Auth with Passcode" : @"Auth with Biometrics" forState:UIControlStateNormal];
    
    //update auth btn
    [self hideAuthButtonWithCompletion:^(BOOL finished) {
        if(!index || [[JCAuthenticationHanlder sharedHelper] hasCreatePasscode]){
            [self showAuthButtonWithCompletion:nil];
        }
    }];
    
    //update nav right button
    [self updateNavRighButton];
}


#pragma mark - Local authentication
- (void)showSetPassword{
    [[JCAuthenticationHanlder sharedHelper] createNewPasswordWithTitle:@"Create new passcode"
                                                            completion:^(BOOL success, NSString *errorMsg) {
                                                                [self updateNavRighButton];
                                                                if(success){
                                                                    [self showAuthButtonWithCompletion:nil];
                                                                }
                                                                else{
                                                                    [JCUIAlertUtils toastWithMessage:errorMsg
                                                                                              colour:TOAST_MESSAGE_RED];
                                                                }
                                                            }];
}

- (void)showChangePasscode{
    [[JCAuthenticationHanlder sharedHelper] changePasswordWithTitle:@"Change passcode" completion:^(BOOL success, NSString *errorMsg) {
        [JCUIAlertUtils toastWithMessage:success ? @"Passcode changed" :errorMsg
                                  colour:success ? TOAST_MESSAGE_GREEN : TOAST_MESSAGE_RED];
    }];
}

- (void)showPasscodeAuthentication{
    [[JCAuthenticationHanlder sharedHelper] authenticateWithPasswordWithTitle:@"This is a demo title" completion:^(BOOL success, NSString *errorMsg) {
        if([errorMsg isEqualToString:ERROR_FORGOT_PASSCODE_CLCIKED]){
            //forget passcode clicked
            [JCUIAlertUtils toastWithMessage:@"Forget passcode clicked"
                                      colour:TOAST_MESSAGE_GREEN];
        }
        else{
            [JCUIAlertUtils toastWithMessage:success ? @"Passcode auth success" :errorMsg
                                      colour:success ? TOAST_MESSAGE_GREEN : TOAST_MESSAGE_RED];
        }
    }];
}

- (void)showBiometricsAuthentication{
    [[JCAuthenticationHanlder sharedHelper] authenticateWithBiometricsWithTitle:@"This is a demo title" completion:^(BOOL success, NSError *error) {
        [JCUIAlertUtils toastWithMessage:success ? @"Biometrics auth success" : [error localizedDescription]
                                  colour:success ? TOAST_MESSAGE_GREEN : TOAST_MESSAGE_RED];
    }];
}

#pragma mark - RvrBarButtonItem Delegate
- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    switch (btnType) {
        case RightBarButtonTypeAdd:
            [self showSetPassword];
            break;
            
        case RightBarButtonTypeChange:
            [self showChangePasscode];
            break;
    }
}
@end
