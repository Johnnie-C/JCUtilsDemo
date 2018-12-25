//
//  PAPasscodeViewController.h
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PasscodeActionSet,
    PasscodeActionEnter,
    PasscodeActionChange
} PasscodeAction;

typedef NS_ENUM(NSInteger, PasscodeEnterPurpose) {
    PasscodeEnterPurposePayment
} ;


//TODO: clean up how to check passcode

@class PAPasscodeViewController;

@protocol PAPasscodeViewControllerDelegate <NSObject>

@required
- (BOOL)isPasscodeValid:(NSString *)passcode;

@optional

- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerChangePasscodeError:(NSString *)errorMsg;
- (void)PAPasscodeViewControllerDidEnterAlternativePasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller;
- (void)PAPasscodeViewController:(PAPasscodeViewController *)controller didFailToEnterPasscode:(NSInteger)attempts;
- (void)PAPasscodeViewControllerOnForgotPasscodeClicked:(PAPasscodeViewController *)controller;

@end




@interface PAPasscodeViewController : UIViewController {
    NSArray *_installedConstraints;
    UIView *_inputPanel;
    NSLayoutConstraint *_keyboardHeightConstraint;
    UIView *contentView;
    NSInteger phase;
    UILabel *promptLabel;
    UILabel *messageLabel;
    UIView *_failedAttemptsView;
    UILabel *failedAttemptsLabel;
    UITextField *passcodeTextField;
    UILabel *_digitLabels[4];
    UIImageView *snapshotImageView;
    UIButton *btnForgorPasscode;
}

@property (strong) UIView *backgroundView;
@property (readonly) PasscodeAction action;
@property (assign) PasscodeEnterPurpose passcodeEnterPurpose;
@property (weak) id<PAPasscodeViewControllerDelegate> delegate;
@property (strong) NSString *passcode;
@property (assign) BOOL simple;
@property (assign) NSInteger failedAttempts;
@property (strong) NSString *enterPrompt;
@property (strong) NSString *confirmPrompt;
@property (strong) NSString *changePrompt;
@property (strong) NSString *message;
@property (strong) UIColor *rightCancelColor;

- (id)initForAction:(PasscodeAction)action;

@end
