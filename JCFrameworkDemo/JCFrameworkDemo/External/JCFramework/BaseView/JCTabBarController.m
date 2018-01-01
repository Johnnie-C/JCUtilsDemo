//
//  JCTabBarController.m
//  
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2015 Putti. All rights reserved.
//

#import "JCTabBarController.h"

#import "UIImage+JCUtils.h"
#import "UIColor+JCUtils.h"
#import "UIView+JCUtils.h"
#import "JCUtils.h"
#import "UIFont+JCUtils.h"


@interface JCTabBarController ()

@property (nonatomic, assign) CGFloat tabbarHeight;
@property (nonatomic, assign) BOOL hasInitTabSelectItemBackgroundColor;

@end






@implementation JCTabBarController

- (instancetype)init{
    if (self = [super init]){
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //init selected item background
    if(!_hasInitTabSelectItemBackgroundColor){
        [self setSelectedItemBackgroundForIndex:0];
        _hasInitTabSelectItemBackgroundColor = YES;
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self setSelectedItemBackgroundForIndex:self.selectedIndex];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];
}

- (void)setupTabBar{
    self.delegate = self;
    [self.tabBar setBarTintColor:[UIColor tabbarBackgroundColor]];
    
    if([UIColor tabbarTitleColor]){
        [UITabBarItem.appearance setTitleTextAttributes:@{
                                                          NSForegroundColorAttributeName : [UIColor tabbarTitleColor],
                                                          NSFontAttributeName : [UIFont fontWithSize:12]
                                                          }
                                               forState:UIControlStateNormal];
    }
    
    [UITabBarItem.appearance setTitleTextAttributes:@{
                                                      NSForegroundColorAttributeName : [UIColor tabbarSelectedTitleColor],
                                                      NSFontAttributeName : [UIFont fontWithSize:12]
                                                      }
                                           forState:UIControlStateSelected];
}

- (void)setSelectedItemBackgroundForIndex:(NSInteger)index{
//    UIColor *selectedTabBackgroundColor = [self selectedTabBackgroundColorForIndex:index];
//    self.tabBar.selectionIndicatorImage = [UIImage imageWithColor:selectedTabBackgroundColor size:CGSizeMake([self tabbarItemWidth], self.tabBar.height)];
}

- (CGFloat)tabbarItemWidth{
    CGFloat width = self.tabBar.width / self.viewControllers.count;
    if([JCUtils isIPad] || ([JCUtils isIPhoneX] && [JCUtils isLandscape])){
        for(UIView *subview in self.tabBar.subviews){
            if([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]){
                width = subview.width;
                break;
            }
        }
    }
    
    return width;
}

#pragma mark - tabbar delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger index = [[tabBarController viewControllers] indexOfObject:viewController];
    [self setSelectedItemBackgroundForIndex:index];
}

- (UIColor *)selectedTabBackgroundColorForIndex:(NSInteger)index{
    UIColor *color;
    switch (index) {
        case 0:
            //TODO: to implement
            color = [UIColor blackColor];
            break;
        case 1:
            //TODO: to implement
            color = [UIColor redColor];
            break;
        case 2:
            //TODO: to implement
            color = [UIColor blueColor];
            break;
        case 3:
            //TODO: to implement
            color = [UIColor yellowColor];
            break;
            
        default:
            color = [UIColor clearColor];
            break;
    }
    
    return color;
}

@end
