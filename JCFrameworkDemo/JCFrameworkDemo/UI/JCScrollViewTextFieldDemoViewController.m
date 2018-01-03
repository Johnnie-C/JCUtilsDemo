//
//  JCScrollViewTextFieldDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCScrollViewTextFieldDemoViewController.h"

#import "JCErrorTextField.h"
#import "NSString+JCUtils.h"
#import "UIView+JCUtils.h"
#import "JCScrollableViewKeyboardHandler.h"

@interface JCScrollViewTextFieldDemoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet JCErrorTextField *txtEmail;
@property (weak, nonatomic) IBOutlet JCErrorTextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

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
    
    //important !!
    //listen to the position of last textField to adjust the content size
    [_txtPassword addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_scrollableViewKeyboardHandler unregister];
    [_txtPassword removeObserver:self forKeyPath:@"center"];
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
    [_btnCheck addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkEmail)] ];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object == _txtPassword && [keyPath isEqualToString:@"center"]){
        _const_contentViewHeight.constant = _lbContent.bottom + 20;
    }
}

- (void)checkEmail{
    _txtEmail.error = [_txtEmail.text isValidEmail] ? nil : @"Invalid Email";
}

@end
