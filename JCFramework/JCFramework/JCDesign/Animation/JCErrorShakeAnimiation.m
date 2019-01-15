//
//  JCErrorShakeAnimiation.m
//
//  Created by Johnnie on 5/03/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCErrorShakeAnimiation.h"
#include "UIView+JCUtils.h"

@interface JCErrorShakeAnimiation()

@property (weak, nonatomic) UIView *view;

@end

@implementation JCErrorShakeAnimiation

+ (instancetype)animationOnView:(UIView *)view{
    JCErrorShakeAnimiation *animation = [JCErrorShakeAnimiation animationWithKeyPath:@"position"];
    animation.view = view;
    [animation setDuration:0.05];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                        CGPointMake(view.center.x - 3.0f, view.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                      CGPointMake(view.center.x + 3.0f, view.center.y)]];
    return animation;
}

- (void)animate{
    [[_view layer] addAnimation:self forKey:@"position"];
}

@end
