//
//  JCFloatingViewController.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCFloatingViewConfig, JCFloatingViewController;


@protocol JCFloatingViewControllerDelegate <NSObject>

@optional
- (void)didClickedFloatingView:(JCFloatingViewController *)floatingView;
- (void)didDismissFloatingView:(JCFloatingViewController *)floatingView;

@end





@interface JCFloatingViewController : UIViewController

@property(nonatomic, readonly) BOOL isShowing;
@property (nonatomic, weak) NSObject<JCFloatingViewControllerDelegate> *delegate;

+ (instancetype)FloatingViewWithConfig:(JCFloatingViewConfig *)config;

- (void)showFloatingView;
- (void)hideFloatingView;
- (void)dismissFloatingView;


@end


