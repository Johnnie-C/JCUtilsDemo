//
//  JCBaseViewController.h
//  
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCBarButtonItem.h"


@interface JCBaseViewController : UIViewController<JCBarButtonItemDelegate, UIAlertViewDelegate>{
    BOOL isShowingLoader;
}

- (instancetype)initWithOwnNib;
- (instancetype)initWithNib:(NSString *)nibName;

- (void)setTabBarImageName:(NSString *)imageName;
- (void)showStatusBarBackgroundWithColour:(UIColor *)colour;
- (void)hideNavigationBar:(BOOL)isHide;

- (void)setLeftBarButtonType:(LeftBarButtonType)type;
- (NSArray<UIBarButtonItem *> *)setRightBarButtonTypes:(NSArray<NSNumber *> *)types;

- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;
- (void)showActionSheet:(UIViewController *)vc;

@end
