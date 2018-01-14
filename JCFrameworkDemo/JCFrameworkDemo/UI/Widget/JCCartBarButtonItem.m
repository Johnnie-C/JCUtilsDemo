//
//  JCCartBarButtonItem.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 14/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCCartBarButtonItem.h"

#import "UIView+JCUtils.h"
#import "UIColor+JCUtils.h"
#import "UIFont+JCUtils.h"

@interface JCCartBarButtonItem()


@end





@implementation JCCartBarButtonItem

- (instancetype)init{
    if([super init]){
        self.animatedAddCart = YES;
    }
    
    return self;
}

- (void)setupAdditionalView{
    CGFloat lbCountSize = 15;
    _lbCount = [[JCLabel alloc] initWithFrame:CGRectMake(0, 0, lbCountSize, lbCountSize)];
    _lbCount.backgroundColor = [UIColor whiteColor];
    _lbCount.clipsToBounds = YES;
    _lbCount.layer.cornerRadius = lbCountSize / 2;
    _lbCount.layer.borderColor = [UIColor navigationbarBackgroundColor].CGColor;
    _lbCount.layer.borderWidth = 1;
    _lbCount.font = [UIFont fontWithType:JCFontTypeRegular size:9];
    _lbCount.textColor = [UIColor blackColor];
    _lbCount.textAlignment = NSTextAlignmentCenter;
    _lbCount.adjustsFontSizeToFitWidth = YES;
    _lbCount.hidden = YES;
    [self.containerView addSubview:_lbCount];
}

- (void)setCartCount:(NSInteger)count{
    _cartCount = count;
    [self performAddCart];
}

- (void)addCartCountBy:(NSInteger)addBy{
    _cartCount += addBy;
    [self performAddCart];
}

- (void)performAddCart{
    _lbCount.text = [NSString stringWithFormat:@"%ld", (long)_cartCount];
    _lbCount.hidden = _cartCount > 0 ? NO : YES;
    
    if(_cartCount > 0 && _animatedAddCart){
        [self playAddCartAnimation];
    }
}

- (void)playAddCartAnimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat wobbleAngle = 0.1f;
    
    NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0f, 0.0f, 1.0f)];
    NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0f, 0.0f, 1.0f)];
    animation.values = [NSArray arrayWithObjects:valLeft, valRight, nil];
    animation.autoreverses = YES;
    animation.duration = 0.05f;
    animation.repeatCount = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.containerView.layer addAnimation:animation forKey:nil];
}

@end
