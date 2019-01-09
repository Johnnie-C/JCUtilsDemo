//
//  JCStretchHeaderViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCStretchHeaderViewController.h"


@interface JCStretchHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_contentViewHeight;
@property (strong, nonatomic) UIImageView *headerView;

@property (strong, nonatomic) JCStretchHeaderHandler *stretchHeaderHandler;

@end





@implementation JCStretchHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupHeaderView];
    [self setupContentView];
}

- (BOOL)preventViewControllerBehindNavigationBar{
    //important!!
    //to extend viewController to the top of the screen
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _stretchHeaderHandler = [[JCStretchHeaderHandler alloc] initWithHeader:_headerView
                                                                scrollView:_scrollView
                                                             navigationBar:self.navigationController.navigationBar
                                                            navigationItem:self.navigationItem];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_stretchHeaderHandler destory];
}

- (void)setupNavBar{
    self.title = @"Stretchable header demo";
    self.extendedLayoutIncludesOpaqueBars = YES;//important!!
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
    [self setRightBarButtonTypes:@[@(RightBarButtonTypeSearch)]];
}

- (void)setupHeaderView{
    _headerView = [UIImageView new];
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.image = [UIImage imageNamed:@"demo_image.jpeg"];
}

- (void)setupContentView{
    _lbContent.text = @"A demo for stretchable header in scroll view with fade in/out navigationbar effect.\n\nThis handler should also work for UITableView and UICollectionView, but hasn't been fully tested yet.\n\n\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\nSome placeholder to make it scrollable\n\nThis is the end";
    [_lbContent sizeToFit];
    _const_contentViewHeight.constant = _lbContent.bottom + 20;
}

#pragma mark - NavBarButtonItem Delegate
- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    [JCToast toastWithMessage:@"Right search clicked" colour:[UIColor toastMessageGreen]];
}

@end
