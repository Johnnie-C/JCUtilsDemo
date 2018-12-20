//
//  JSFloatingViewController.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCFloatingViewConfig, JSFloatingViewController;


@protocol JSFloatingViewControllerDelegate <NSObject>

@optional
- (void)didClickedFloatingView:(JSFloatingViewController *)floatingView;
- (void)didDismissFloatingView:(JSFloatingViewController *)floatingView;

@end





@interface JSFloatingViewController : UIViewController

@property(nonatomic, readonly) BOOL isShowing;
@property (nonatomic, weak) NSObject<JSFloatingViewControllerDelegate> *delegate;

+ (instancetype)FloatingViewWithConfig:(JCFloatingViewConfig *)config;

- (void)showFloatingView;
- (void)hideFloatingView;
- (void)dismissFloatingView;


@end


