//
//  JSBaseFloatingView.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSBaseFloatingView.h"
#import "UIView+JCUtils.h"
#import "JCUtils.h"

@interface JSBaseFloatingView ()<UIGestureRecognizerDelegate>

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
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 10;
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
    gr.delegate = self;
    [self.view addGestureRecognizer:gr];
}

- (void)handleDragGesture:(UIPanGestureRecognizer *)panGesture {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if(panGesture.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [panGesture translationInView:window];
        CGFloat newX = self.view.x + translation.x;
        CGFloat newY = self.view.y + translation.y;
        if(newX  < [JCUtils safeMarginLeft]){//add pull effect
            newX = [JCUtils safeMarginLeft];
        }
        else if(newX + self.view.width > [JCUtils screenWidth] - [JCUtils safeMarginRight]){
            newX = [JCUtils screenWidth] - [JCUtils safeMarginRight] - self.view.width;
        }
        if(newY  < [JCUtils safeMarginTop]){//add pull effect
            newY = [JCUtils safeMarginTop];
        }
        else if(newY + self.view.height > [JCUtils screenHeight] - [JCUtils safeMarginBottom]){
            newY= [JCUtils screenHeight] - [JCUtils safeMarginBottom] - self.view.height;
        }
   
        [self.view setX:newX];
        [self.view setY:newY];
        [panGesture setTranslation:CGPointZero inView:window];
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:_scrollView.superview];
//        if (fabs(translation.x) > fabs(translation.y)) {
//            return YES;
//        }
//        return NO;
    }
    return YES;
}

@end
