//
//  JCScrollViewTextFieldDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCScrollViewTextFieldDemoViewController.h"

#import "JCErrorTextField.h"
#import "JCScrollableViewKeyboardHandler.h"

@interface JCScrollViewTextFieldDemoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JCErrorTextField *txtEmail;
@property (weak, nonatomic) IBOutlet JCErrorTextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_contentViewHeight;

@property (strong, nonatomic) JCScrollableViewKeyboardHandler *scrollableViewKeyboardHandler;

@end





@implementation JCScrollViewTextFieldDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupScrollView];
    [self setupContentView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_scrollableViewKeyboardHandler registerResposeScrollViewForKeyBoard:_scrollView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_scrollableViewKeyboardHandler unregister];
}

- (void)setupNavBar{
    self.title = @"ScrollView & Customised TextField demo";
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
}

- (void)setupScrollView{
    _scrollableViewKeyboardHandler = [JCScrollableViewKeyboardHandler new];
}

- (void)setupContentView{
    _txtPassword.textField.secureTextEntry = YES;
}

@end
