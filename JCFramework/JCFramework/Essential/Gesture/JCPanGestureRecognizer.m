//
//  JCPanGestureRecognizer.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCPanGestureRecognizer.h"


@interface JCPanGestureRecognizer()

@property (nonatomic, assign) NSTimeInterval touchDownTime;
@property (nonatomic, assign) NSTimeInterval touchUpTime;
@property (nonatomic, assign) CGPoint touchDownPoint;
@property (nonatomic, assign) CGPoint touchUpPoint;

@end





@implementation JCPanGestureRecognizer

- (instancetype)init{
    if(self = [super init]){
        self.delaysTouchesEnded = NO;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.state == UIGestureRecognizerStatePossible) {
        if(_pressDelegate){
            [_pressDelegate didPress: self];
        }
        self.state = UIGestureRecognizerStateBegan;
        _touchDownTime = [[NSDate date] timeIntervalSince1970];
        _touchDownPoint = [self locationInView:self.view.superview];
        _touchUpTime = 0;
        _touchUpPoint = CGPointZero;
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    _touchUpTime = [[NSDate date] timeIntervalSince1970];
    _touchUpPoint = [self locationInView:self.view.superview];
}

- (BOOL)isTap{
    return _touchUpTime && _touchDownTime && _touchUpTime - _touchDownTime < 0.3
    && ABS(_touchUpPoint.x - _touchDownPoint.x) < 5 && ABS(_touchUpPoint.y - _touchDownPoint.y) < 5;
}

@end
