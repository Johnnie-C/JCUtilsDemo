//
//  JSBaseFloatingViewController.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JSBaseFloatingViewController : UIViewController

@property(nonatomic, readonly) BOOL isShowing;

- (void)showFloatingView;
- (void)hideFloatingView;
- (void)dismissFloatingView;


@end


