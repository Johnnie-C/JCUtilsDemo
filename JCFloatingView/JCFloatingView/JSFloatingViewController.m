//
//  JSFloatingViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSFloatingViewController.h"
#import "JCFloatingWindow.h"
#import <JCFramework/JCFramework.h>


typedef NS_ENUM(NSInteger, JCFoatingViewCloestEdge){
    JCFoatingViewCloestEdgeLeft,
    JCFoatingViewCloestEdgeTop,
    JCFoatingViewCloestEdgeRight,
    JCFoatingViewCloestEdgeBottom
};





@interface JSFloatingViewController ()

@property (nonatomic, strong) JCFloatingWindow *window;
@property (nonatomic, assign) JCFoatingViewCloestEdge cloestEdge;
@property (nonatomic, assign) CGFloat closeViewHeight;
@property (nonatomic, strong) CAGradientLayer *closeViewGradientLayer;

@property (weak, nonatomic) IBOutlet UIImageView *ivCloseBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivClose;

@property (weak, nonatomic) IBOutlet UIView *closeBaseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_closeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseWidth;


@property (nonatomic, assign) BOOL hasTriggerCloseAnimation;

@end






@implementation JSFloatingViewController

- (void)showFloatingView{
    [self setupFloatingViewIfNeed];
    _window.hidden = NO;
    _isShowing = YES;
}

- (void)hideFloatingView{
    _window.hidden = YES;
    _isShowing = NO;
}

- (void)dismissFloatingView{
    [_window reset];
    _window.hidden = YES;
    _isShowing = NO;
}

- (instancetype)init{
    if (self = [self initWithNibName:NSStringFromClass([JSFloatingViewController class]) bundle:[NSBundle bundleForClass:[JSFloatingViewController class]]]){
        _closeViewHeight = 120;
        _window = [[JCFloatingWindow alloc] initWithFrame: CGRectMake(0, 0, [JCUtils screenWidth], [JCUtils screenHeight])];
        _window.rootViewController = self;
        _window.windowLevel = UIWindowLevelAlert - 1;
        [_window makeKeyAndVisible];
    }
    
    return self;
}

/**
 override this to create a floating view
 
 @return floating view
 */
- (UIView *)createFloatingView{
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupCloseView];
    [self setupFloatingViewIfNeed];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if(_window.floatingView){
            [self handleFloatingViewRotation];
        }
    }];
}

- (void)setupFloatingViewIfNeed{
    if(!_window.floatingView){
        UIView *floatingView = [self createFloatingView];
        floatingView.userInteractionEnabled = YES;
        [self.view addSubview:floatingView];
        _window.floatingView = floatingView;
        _cloestEdge = JCFoatingViewCloestEdgeRight;
        [_window.floatingView addGestureRecognizer:[[JCPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)]];
        [self.view bringSubviewToFront:_closeBaseView];
    }
}

- (void)setupCloseView{
    //setup gradient background
    if(_closeViewGradientLayer){
        [_closeViewGradientLayer removeFromSuperlayer];
    }
    _closeViewGradientLayer = [CAGradientLayer layer];
    _closeViewGradientLayer.frame = CGRectMake(0, 20, [JCUtils screenWidth], _closeViewHeight + 20);
    UIColor *topColor = [UIColor clearColor];
    UIColor *bottomColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    _closeViewGradientLayer.colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
    _closeViewGradientLayer.locations = @[@(0.0), @(0.5)];
    [_closeBaseView.layer insertSublayer:_closeViewGradientLayer atIndex:0];
    
    //setup close image
    _ivCloseBG.backgroundColor = [[UIColor cancelRed] colorWithAlphaComponent:0.8];
    _ivCloseBG.clipsToBounds = YES;
    _ivCloseBG.layer.cornerRadius = _ivCloseBG.height / 2;
    _ivClose.image = [UIImage imageNamed:@"ic_close" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
}

- (void)handleFloatingViewRotation{
    CGFloat finalX = _window.floatingView.x;
    CGFloat finalY = _window.floatingView.y;
    
    switch (_cloestEdge) {
        case JCFoatingViewCloestEdgeLeft:
            finalX = [self floatingViewMinX];
            break;
            
        case JCFoatingViewCloestEdgeTop:
            finalY = [self floatingViewMinY];
            break;
            
        case JCFoatingViewCloestEdgeRight:
            finalX = [self floatingViewMaxX];
            break;
            
        case JCFoatingViewCloestEdgeBottom:
            finalY = [self floatingViewMaxY];
            break;
    }
    
    _window.floatingView.x = finalX;
    _window.floatingView.y = finalY;
    [self finaliseFloatingViewWithVelocity:CGPointZero animated:NO];
    [self setupCloseView];
}

- (CGFloat)floatingViewMinX{
    return [JCUtils safeMarginLeft];
}

- (CGFloat)floatingViewMaxX{
    return  [JCUtils screenWidth] - [JCUtils safeMarginRight] - _window.floatingView.width;
}

- (CGFloat)floatingViewMinY{
    return [JCUtils safeMarginTop];
}

- (CGFloat)floatingViewMaxY{
    return  [JCUtils screenHeight] - [JCUtils safeMarginBottom] - _window.floatingView.height;
}

- (void)showCloseView:(BOOL)isShow{
    _const_closeViewHeight.constant = isShow ? _closeViewHeight : 0;
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)animateCloseButtonIfNeed:(CGPoint)currentTouchPoint{
    CGPoint triggerCenter = [_ivCloseBG centerInView:self.view];
    CGFloat triggerRectRadius = _hasTriggerCloseAnimation ? _ivCloseBG.width / 2 : 75;
    CGRect rectToTrigger = CGRectMake(triggerCenter.x - triggerRectRadius, triggerCenter.y - triggerRectRadius, triggerRectRadius * 2, triggerRectRadius * 2);
    CGFloat scale = 1;
    
    CGPoint newFloatingViewCenter = _ivCloseBG.center;
    BOOL shouldAnimate = NO;
    if(CGRectContainsPoint(rectToTrigger, _window.floatingView.center)){
        scale = 1.5f;
        if(!_hasTriggerCloseAnimation){
            newFloatingViewCenter = triggerCenter;
            _hasTriggerCloseAnimation = YES;
            shouldAnimate = YES;
        }
    }
    else{
        if(_hasTriggerCloseAnimation){
            newFloatingViewCenter = currentTouchPoint;
            _hasTriggerCloseAnimation = NO;
            shouldAnimate = YES;
        }
    }
    
    if(shouldAnimate){
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:2
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _window.floatingView.center = newFloatingViewCenter;
                             _ivCloseBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
                         }
                         completion:nil];
    }
    else{
        _ivCloseBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    }
}

- (BOOL)dismissFloatingViewIfNeed{
    BOOL dismissed = NO;
    
    if(_hasTriggerCloseAnimation){
        [self dismissFloatingView];
        dismissed = YES;
    }
        
    return dismissed;
}

- (void)finaliseFloatingViewWithVelocity:(CGPoint)velocity animated:(BOOL)animated{
    UIView *floatingView = _window.floatingView;
    CGFloat velocityX = 0.02 * velocity.x;
    CGFloat velocityY = 0.02 * velocity.y;
    
    CGFloat finalX = floatingView.x + velocityX;
    CGFloat finalY = floatingView.y + velocityY;
    
    CGFloat edgeDistanceLeft = floatingView.x;
    CGFloat edgeDistanceTop = floatingView.y;
    CGFloat edgeDistanceRight = [JCUtils screenWidth] - [JCUtils safeMarginRight] - floatingView.right;
    CGFloat edgeDistanceBottom = [JCUtils screenHeight] - [JCUtils safeMarginBottom] - floatingView.bottom;
    
    if(MIN(edgeDistanceLeft, edgeDistanceRight) <= MIN(edgeDistanceTop, edgeDistanceBottom)){
        //move to left/right
        finalX = floatingView.center.x <= [JCUtils screenWidth] / 2 ? [self floatingViewMinX] : [self floatingViewMaxX];
        _cloestEdge = finalX == [self floatingViewMinX] ? JCFoatingViewCloestEdgeLeft : JCFoatingViewCloestEdgeRight;
    }
    else{
        //move to top/bottom
        finalY = floatingView.center.y <= [JCUtils screenHeight] / 2 ? [self floatingViewMinY] : [self floatingViewMaxY];
        _cloestEdge = finalY == [self floatingViewMinY] ? JCFoatingViewCloestEdgeTop : JCFoatingViewCloestEdgeBottom;
    }
    
    if(animated){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    [floatingView setX:finalX];
    [floatingView setY:finalY];
    if(animated){
        [UIView commitAnimations];
    }
}


#pragma mark - UIGestureRecognizer
- (void)handleDragGesture:(JCPanGestureRecognizer *)panGesture {
    UIView *floatingView = _window.floatingView;
    CGPoint translation = [panGesture translationInView:floatingView.superview];
    CGFloat dragScale = 1;
    if(_hasTriggerCloseAnimation){
        dragScale = 0.2;
    }
    
    CGFloat newX = floatingView.x + translation.x * dragScale;
    CGFloat newY = floatingView.y + translation.y * dragScale;
    
    if(panGesture.state == UIGestureRecognizerStateBegan){
        floatingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged){
        [self showCloseView:YES];
        if(newX  < [JCUtils safeMarginLeft]){//add pull effect
            newX = [JCUtils safeMarginLeft];
        }
        else if(newX > [self floatingViewMaxX]){
            newX = [self floatingViewMaxX];
        }
        if(newY  < [JCUtils safeMarginTop]){//add pull effect
            newY = [JCUtils safeMarginTop];
        }
        else if(newY > [self floatingViewMaxY]){
            newY= [self floatingViewMaxY];
        }
        
        [floatingView setX:newX];
        [floatingView setY:newY];
        [_ivCloseBG setX:_ivCloseBG.x + translation.x * 0.03];
        [_ivCloseBG setY:_ivCloseBG.y + translation.y * 0.03];
        [_ivClose setX:_ivClose.x + translation.x * 0.03];
        [_ivClose setY:_ivClose.y + translation.y * 0.03];
        [panGesture setTranslation:CGPointZero inView:floatingView.superview];
        
        [self animateCloseButtonIfNeed:[panGesture locationInView:self.view]];
    }
    else if(panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled){
        [self showCloseView:NO];
        if([panGesture isTap]){
            [self didClickedfloatingView];
        }
        
        if(![self dismissFloatingViewIfNeed]){
            floatingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            [self finaliseFloatingViewWithVelocity:[panGesture velocityInView:floatingView.superview] animated:YES];
        }
    }
}

- (void)didClickedfloatingView{
    NSLog(@"didClickedfloatingView");
}

@end
