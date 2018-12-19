//
//  JSFloatingView.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSFloatingView.h"
#import <JCFramework/JCFramework.h>

@implementation JSFloatingView

- (UIView *)createFloatingView {
    CGFloat width = 80;
    CGFloat height = 110;
    CGFloat x = [JCUtils screenWidth] - width - [JCUtils safeMarginRight];
    CGFloat y = [JCUtils screenHeight] - height - [JCUtils safeMarginBottom];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    iv.clipsToBounds = YES;
    iv.layer.cornerRadius = 10;
    iv.image = [UIImage imageNamed:@"demo_image.jpeg"];
    
    return iv;
}

@end
