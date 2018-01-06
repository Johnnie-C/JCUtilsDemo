//
//  JCBaseViewController.m
//  
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCBaseViewController.h"

#import "JCUtils.h"
#import "UIColor+JCUtils.h"
#import "UIImage+JCUtils.h"
#import "UIView+JCUtils.h"
#import "JCUIAlertUtils.h"
#import "UINavigationBar+JCUtils.h"

@interface JCBaseViewController (){
    NSString *phoneToCall;
}
@property JCBarButtonItem *rightButtonItem;
@property UIActivityIndicatorView *unblockLoader;
@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIImageView *ivBG;
@end

@implementation JCBaseViewController

#pragma mark - Initialisers

- (instancetype)init{
    if (self = [self initWithOwnNib]){
        self.tabBarItem.title = @"";
    }
    return self;
}

- (instancetype)initWithOwnNib{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:[JCUtils frameworkBundle]];
}

- (instancetype)initWithNib:(NSString *)nibName{
    return [self initWithNibName:nibName bundle:[JCUtils frameworkBundle]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if([self preventViewControllerBehindNavigationBar]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationBar];
    [self setBackgrondImage];
}

- (BOOL)preventViewControllerBehindNavigationBar{
    return YES;
}

- (BOOL)allowNavigationBarTranslucent{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationbarBackgroundColor] extendToStatusBar:YES];
}

- (void)hideNavigationBar:(BOOL) isHide{
    [self.navigationController.navigationBar setHidden:isHide];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Functions
- (void)setupNavigationBar{
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [self.navigationItem setTitle:@""];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationbarBackgroundColor] extendToStatusBar:YES];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor: [UIColor clearColor] size:CGSizeMake([JCUtils screenWidth], 0.5f)];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor navigationbarTextColor]}];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setBackgrondImage{
    if([self hasBackgroundImage] && !_ivBG){
        _ivBG = [UIImageView new];
        _ivBG.image = [UIImage imageNamed:[JCUtils isIPhone] ? @"default_bg_image_iphone.jpg" : @"default_bg_image_ipad.jpg"];
        [self.view insertSubview:_ivBG atIndex:0];
        [_ivBG fillInSuperView];
    }
}

- (BOOL)hasBackgroundImage{
    return NO;
}

- (void)setLeftBarButtonType:(LeftBarButtonType)type{
    JCBarButtonItem *barButtonItem = [[JCBarButtonItem alloc] initWithLeftBarButtonType:type];
    [barButtonItem setDelegate:self];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    CGFloat width = 0;
    if(type == LeftBarButtonTypeBack || type == LeftBarButtonTypeCancel){
        width = - 15;
    }
    [spacer setWidth:width];
    
    [self.navigationItem setLeftBarButtonItems:@[spacer, barButtonItem]];
    [self.navigationItem setHidesBackButton:YES];
}

- (NSArray<UIBarButtonItem *> *)setRightBarButtonTypes:(NSArray<NSNumber *> *)types{
    NSMutableArray<JCBarButtonItem *> *buttons = [NSMutableArray array];
    for(NSNumber *typeNum in types){
        RightBarButtonType type = [typeNum integerValue];
        JCBarButtonItem *btn = [[JCBarButtonItem alloc] initWithRightBarButtonType:type];
        [btn setDelegate:self];
        [buttons addObject:btn];
    }
    
    if(buttons && [buttons count]){
        NSMutableArray *wrappedButtons = [NSMutableArray array];
        UIBarButtonItem *righSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        RightBarButtonType firstBtnType = [[types objectAtIndex:0] integerValue];
        [righSpacer setWidth:0];
        
        [wrappedButtons addObject:righSpacer];
        [wrappedButtons addObjectsFromArray:buttons];
        [self.navigationItem setRightBarButtonItems:wrappedButtons];
    }
    
    return buttons;
}

- (void)setTabBarImageName:(NSString *)imageName{
    [self.tabBarItem setImage:[UIImage originalImageNamed:[NSString stringWithFormat:@"%@", imageName]]];
    [self.tabBarItem setSelectedImage:[UIImage originalImageNamed:[NSString stringWithFormat:@"%@_sel", imageName]]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
}

- (void)showStatusBarBackgroundWithColour:(UIColor *)colour{
    if(_statusBarView){
        [_statusBarView removeFromSuperview];
    }
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [JCUtils statusBarHeight])];
    [_statusBarView setBackgroundColor:colour];
    [self.view insertSubview:_statusBarView atIndex:999];
}

- (BOOL)SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO:(NSString *)version{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version);
}

- (void)pushViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActionSheet:(UIViewController *)vc{
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    UINavigationController *rootNav = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootNav presentViewController:vc animated:NO completion:nil];
}

#pragma mark - unblock loader
- (void)showUnblockLoader{
    if (!isShowingLoader && self.navigationController.view){
        //init loader
        if(!self.unblockLoader){
            self.unblockLoader = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
//            [self.unblockLoader setFrame:CGRectMake(0, 0, self.navigationController.view.width, self.navigationController.view.height)];
            self.unblockLoader.center = self.view.center;
            [self.unblockLoader setBackgroundColor:[UIColor blackColor]];
            [self.unblockLoader setAlpha:0.2f];
        }
        
        [self.navigationController.view bringSubviewToFront:self.unblockLoader];
        [self.unblockLoader setHidden:NO];
        [self.unblockLoader startAnimating];
        [self.navigationController.view addSubview:self.unblockLoader];
        isShowingLoader = YES;
    }
}

- (void)hideUnblockLoader{
    if (self.unblockLoader && isShowingLoader){
        [self.unblockLoader stopAnimating];
        [self.unblockLoader setHidden:YES];
        isShowingLoader = NO;
    }
}


#pragma mark - RvrBarButtonItem Delegate
- (void)shareAction:(id)sender{
    [self rightBarButtonItemTapped:((UIBarButtonItem *)sender).tag];
}

- (void)leftBarButtonItemTapped:(NSInteger)btnType{
    NSLog(@"left bar button item tapped");
    if(btnType == LeftBarButtonTypeBack){
        [self popViewController];
    }
}

- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    NSLog(@"right bar button item tapped: %ld", (long)btnType);
}
@end
