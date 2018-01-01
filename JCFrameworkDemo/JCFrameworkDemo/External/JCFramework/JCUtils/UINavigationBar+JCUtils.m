//
//  UINavigationBar+JCUtils.m
//  Wendys_iOS
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "UINavigationBar+JCUtils.h"

#import "JCUtils.h"
#import "UIImage+JCUtils.h"
#import "UIView+JCUtils.h"

@implementation UINavigationBar (JCUtils)

- (void)setBackgroundColor:(UIColor *)backgroundColor extendToStatusBar:(BOOL)extendToStatusBar{
    CGFloat width = [JCUtils screenWidth];
    CGFloat height = extendToStatusBar ? self.height + [JCUtils statusBarHeight] : self.height;
    UIImage *navImage = [UIImage imageWithColor:backgroundColor size:CGSizeMake(width, height)];
    
    [self setBackgroundImage:navImage forBarPosition:extendToStatusBar ? UIBarPositionTopAttached : UIBarPositionTop barMetrics:UIBarMetricsDefault];
    self.barTintColor = backgroundColor;
}

@end
