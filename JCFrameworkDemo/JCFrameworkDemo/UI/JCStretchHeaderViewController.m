//
//  JCStretchHeaderViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 1/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCStretchHeaderViewController.h"

#import "UINavigationBar+JCUtils.h"
#import "UIView+JCUtils.h"
#import "UIColor+JCUtils.h"
#import "JCStretchHeaderHandler.h"
#import "JCUIAlertUtils.h"

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
    [self.navigationController.navigationBar setBackgroundColor:[UIColor navigationbarBackgroundColorWithAlpha:0] extendToStatusBar:YES];//important!!
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
    _lbContent.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut eros et nisl sagittis vestibulum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Sed lectus. Donec mollis hendrerit risus. Phasellus nec sem in justo pellentesque facilisis. Etiam imperdiet imperdiet orci. Nunc nec neque. Phasellus leo dolor, tempus non, auctor et, hendrerit quis, nisi. Curabitur ligula sapien, tincidunt non, euismod vitae, posuere imperdiet, leo. Maecenas malesuada. Praesent congue erat at massa. Sed cursus turpis vitae tortor. Donec posuere vulputate arcu. Phasellus accumsan cursus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed aliquam, nisi quis porttitor congue, elit erat euismod orci, ac placerat dolor lectus quis orci. Phasellus consectetuer vestibulum elit. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc. Vestibulum fringilla pede sit amet augue. In turpis. Pellentesque posuere. Praesent turpis. Aenean posuere, tortor sed cursus feugiat, nunc augue blandit nunc, eu sollicitudin urna dolor sagittis lacus. Donec elit libero, sodales nec, volutpat a, suscipit non, turpis. Nullam sagittis. Suspendisse pulvinar, augue ac venenatis condimentum, sem libero volutpat nibh, nec pellentesque velit pede quis nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce id purus. Ut varius tincidunt libero. Phasellus dolor. Maecenas vestibulum mollis";
    [_lbContent sizeToFit];
    _const_contentViewHeight.constant = _lbContent.bottom + 20;
}

#pragma mark - RvrBarButtonItem Delegate
- (void)rightBarButtonItemTapped:(NSInteger)btnType{
    [JCUIAlertUtils toastWithMessage:@"Right search clicked" colour:TOAST_MESSAGE_GREEN];
}

@end
