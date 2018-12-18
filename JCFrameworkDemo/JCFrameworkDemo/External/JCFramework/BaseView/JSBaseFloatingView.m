//
//  JSBaseFloatingView.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSBaseFloatingView.h"
#import "UIView+JCUtils.h"

@interface JSBaseFloatingView ()

@end





@implementation JSBaseFloatingView

+ (void)showFloatingView{
    JSBaseFloatingView *vc = [[self alloc] init];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:vc.view];
    [window bringSubviewToFront:vc.view];
}

- (void)hideFloatingView{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
