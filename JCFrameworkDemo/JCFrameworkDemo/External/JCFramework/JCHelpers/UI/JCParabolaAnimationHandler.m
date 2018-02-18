//
//  JCParabolaAnimationHandler.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 14/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCParabolaAnimationHandler.h"

#import "UIView+JCUtils.h"

@interface JCParabolaAnimationHandler()

@property (nonatomic, weak) UIView *viewToAnimate;
@property (nonatomic, copy) JCParabloaAnimationCompletion completion;

@end





@implementation JCParabolaAnimationHandler

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaultValue];
    }
    
    return self;
}

- (void)setupDefaultValue{
    _duration = 0.3f;
}

- (void)startAnimationandView:(UIView *)view
                   startPoint:(CGPoint)startPoint
                     endPoint:(CGPoint)endPoint endSize:(CGSize)endSize
                complemention:(JCParabloaAnimationCompletion)completion
{
    _viewToAnimate = view;
    _completion = completion;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    view.center = startPoint;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:CGPointMake(startPoint.x + (endPoint.x - startPoint.x) / 2 ,
                                                                MIN(startPoint.y, endPoint.y) - 50)];
    
    //path animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(endSize.width / view.width, endSize.height / view.height, 1)];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //add animiations to group
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation, scaleAnimation];
    groups.duration = _duration;
    groups.delegate = self;
    //prevent animated view go back to init position and size after animation end
    groups.fillMode = kCAFillModeForwards;
    groups.removedOnCompletion = NO;
    
    [view.layer addAnimation:groups forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_viewToAnimate removeFromSuperview];
    _viewToAnimate = nil;
    
    if(_completion){
        _completion();
    }
    
    _completion = nil;
}

@end

