//
//  JCFloatingWindow.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCFloatingWindow.h"

@implementation JCFloatingWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(CGRectContainsPoint(_floatingView.frame, point)){
        return _floatingView;
    }
    
    return nil;
}

@end
