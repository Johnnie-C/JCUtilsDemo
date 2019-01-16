//
//  UINavigationBar+JCUtils.m
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "UINavigationBar+JCUtils.h"

#import "JCUtils.h"
#import "UIImage+JCUtils.h"
#import "UIView+JCUtils.h"

@implementation UINavigationBar (JCUtils)

- (void)setBackgroundColor:(UIColor *)backgroundColor extendToStatusBar:(BOOL)extendToStatusBar{
    if (@available(iOS 11.0, *)) {
        self.barTintColor = backgroundColor;
    }
    else{
        CGFloat width = [JCUtils screenWidth];
        CGFloat height = extendToStatusBar ? self.height + [JCUtils statusBarHeight] : self.height;

        UIImage *navImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(width, height)];
        [self setBackgroundImage:navImage forBarPosition:extendToStatusBar ? UIBarPositionTopAttached : UIBarPositionTop barMetrics:UIBarMetricsDefault];
        self.barTintColor = backgroundColor;
    }
}

@end
