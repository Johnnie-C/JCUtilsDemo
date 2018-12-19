//
//  JSBaseFloatingViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSBaseFloatingViewController.h"
#import "JCFloatingWindow.h"
#import "JCPanGestureRecognizer.h"
#import "UIView+JCUtils.h"
#import "JCUtils.h"


@interface JSBaseFloatingViewController ()

@property (nonatomic, strong) JCFloatingWindow *window;

@end





@implementation JSBaseFloatingViewController

- (void)showFloatingView{
    _window.floatingView.hidden = YES;
    _isShowing = YES;
}

- (void)hideFloatingView{
    _window.floatingView.hidden = NO;
    _isShowing = NO;
}

- (instancetype)init{
    if (self = [super init]){
        _window = [[JCFloatingWindow alloc] initWithFrame: CGRectMake(0, 0, [JCUtils screenWidth], [JCUtils screenHeight])];
        _window.rootViewController = self;
        _window.windowLevel = UIWindowLevelAlert;
        [_window makeKeyAndVisible];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!_window.floatingView){
        self.view.backgroundColor = [UIColor clearColor];
        UIView *floatingView = [self createFloatingView];
        floatingView.userInteractionEnabled = YES;
        [self.view addSubview:floatingView];
        _window.floatingView = floatingView;
        [self showFloatingView];
        
        [self.view addGestureRecognizer:[[JCPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)]];
    }
}


//TODO: handle rotation



/**
 override this to create a floating view

 @return floating view
 */
- (UIView *)createFloatingView{
    return nil;
}


#pragma mark - UIGestureRecognizer
- (void)handleDragGesture:(JCPanGestureRecognizer *)panGesture {
    UIView *floatingView = _window.floatingView;
    CGPoint translation = [panGesture translationInView:floatingView.superview];
    
    CGFloat newX = floatingView.x + translation.x;
    CGFloat newY = floatingView.y + translation.y;
    CGFloat maxX = [JCUtils screenWidth] - [JCUtils safeMarginRight] - floatingView.width;
    CGFloat maxY = [JCUtils screenHeight] - [JCUtils safeMarginBottom] - floatingView.height;
    
    if(panGesture.state == UIGestureRecognizerStateBegan){
        floatingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged){
        if(newX  < [JCUtils safeMarginLeft]){//add pull effect
            newX = [JCUtils safeMarginLeft];
        }
        else if(newX > maxX){
            newX = maxX;
        }
        if(newY  < [JCUtils safeMarginTop]){//add pull effect
            newY = [JCUtils safeMarginTop];
        }
        else if(newY > maxY){
            newY= maxY;
        }
        
        [floatingView setX:newX];
        [floatingView setY:newY];
        [panGesture setTranslation:CGPointZero inView:floatingView.superview];
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled){
        if([panGesture isTap]){
            [self didClickedfloatingView];
        }
        
        floatingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        [self finaliseFloatingViewWithVelocity:[panGesture velocityInView:floatingView.superview]];
    }
}

- (void)finaliseFloatingViewWithVelocity:(CGPoint)velocity{
    UIView *floatingView = _window.floatingView;
    CGFloat velocityX = 0.02 * velocity.x;
    CGFloat velocityY = 0.02 * velocity.y;
    
    CGFloat finalX = floatingView.x + velocityX;
    CGFloat finalY = floatingView.y + velocityY;
    
    CGFloat maxX = [JCUtils screenWidth] - [JCUtils safeMarginRight] - floatingView.width;
    CGFloat maxY = [JCUtils screenHeight] - [JCUtils safeMarginBottom] - floatingView.height;
    CGFloat edgeDistanceLeft = floatingView.x;
    CGFloat edgeDistanceTop = floatingView.y;
    CGFloat edgeDistanceRight = [JCUtils screenWidth] - [JCUtils safeMarginRight] - floatingView.right;
    CGFloat edgeDistanceBottom = [JCUtils screenHeight] - [JCUtils safeMarginBottom] - floatingView.bottom;
    
    if(MIN(edgeDistanceLeft, edgeDistanceRight) <= MIN(edgeDistanceTop, edgeDistanceBottom)){
        //move to left/right
        finalX = floatingView.center.x <= [JCUtils screenWidth] / 2 ? 0 : maxX;
    }
    else{
        //move to top/bottom
        finalY = floatingView.center.y <= [JCUtils screenHeight] / 2 ? 0 : maxY;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [floatingView setX:finalX];
    [floatingView setY:finalY];
    [UIView commitAnimations];
}

- (void)didClickedfloatingView{
    NSLog(@"didClickedfloatingView");
}

@end
