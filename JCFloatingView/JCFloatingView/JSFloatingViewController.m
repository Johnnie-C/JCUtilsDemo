//
//  JSFloatingViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSFloatingViewController.h"
#import "JCFloatingWindow.h"
#import "JCFloatingViewConfig.h"
#import <JCFramework/JCFramework.h>


typedef NS_ENUM(NSInteger, JCFoatingViewClosestEdge){
    JCFoatingViewClosestEdgeUnknown,
    JCFoatingViewClosestEdgeLeft,
    JCFoatingViewClosestEdgeTop,
    JCFoatingViewClosestEdgeRight,
    JCFoatingViewClosestEdgeBottom
};





@interface JSFloatingViewController ()<JCPanGestureRecognizerPressDelegate>

@property (nonatomic, strong) JCFloatingViewConfig *config;

@property (nonatomic, strong) JCFloatingWindow *window;
@property (nonatomic, assign) JCFoatingViewClosestEdge closestEdge;
@property (nonatomic, assign) CGFloat closeViewHeight;
@property (nonatomic, strong) CAGradientLayer *closeViewGradientLayer;

@property (weak, nonatomic) IBOutlet UIImageView *ivCloseBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivClose;

@property (weak, nonatomic) IBOutlet UIView *closeBaseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_closeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseBGHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_ivCloseBGWidth;

@property (nonatomic, assign) BOOL hasTriggerCloseAnimation;
@property (nonatomic, assign) CGPoint floatingViewLatestKnownPosition;

@end






@implementation JSFloatingViewController

#pragma mark - initialise
+ (instancetype)FloatingViewWithConfig:(JCFloatingViewConfig *)config{
    return [[JSFloatingViewController alloc] initWithConfig:config];
}

- (instancetype)init{
    if (self = [self initWithConfig:nil]){
        
    }
    
    return self;
}

- (instancetype)initWithConfig:(JCFloatingViewConfig *)config{
    if (self = [self initWithNibName:NSStringFromClass([JSFloatingViewController class]) bundle:[NSBundle bundleForClass:[JSFloatingViewController class]]]){
        [self _initWithConfig:config];
    }
    
    return self;
}

- (void)_initWithConfig:(JCFloatingViewConfig *)config{
    _config = config ? config : [JCFloatingViewConfig new];
    _closeViewHeight = 120;
    _window = [[JCFloatingWindow alloc] initWithFrame: CGRectMake(0, 0, [JCUtils screenWidth], [JCUtils screenHeight])];
    _window.rootViewController = self;
    _window.windowLevel = UIWindowLevelAlert - 1;
    [_window makeKeyAndVisible];
}


#pragma mark - setup

- (UIStatusBarStyle)preferredStatusBarStyle{
    return _config.preferredStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setupCloseView{
    //setup gradient background
    if(_closeViewGradientLayer){
        [_closeViewGradientLayer removeFromSuperlayer];
    }
    _closeViewGradientLayer = [CAGradientLayer layer];
    _closeViewGradientLayer.frame = CGRectMake(0, 20, [JCUtils screenWidth], _closeViewHeight + 20);
    _closeViewGradientLayer.colors = _config.closeViewGradientColors;
    _closeViewGradientLayer.locations = _config.closeViewGradientColorsLocations;
    [_closeBaseView.layer insertSublayer:_closeViewGradientLayer atIndex:0];
    
    
    //setup close image
    _const_ivCloseWidth.constant = _config.closeImageWidth;
    _const_ivCloseHeight.constant = _config.closeImageHeight;
    _ivClose.image = _config.closeImage;
    _ivClose.clipsToBounds = YES;
    _ivClose.layer.cornerRadius = _config.closeImageCornerRadius < 0 ?  _const_ivCloseWidth.constant / 2 : _config.closeImageCornerRadius;
    
    //setup close bg image
    _const_ivCloseBGWidth.constant = _config.closeBGImageWidth;
    _const_ivCloseBGHeight.constant = _config.closeBGImageHeight;
    _ivCloseBG.image = _config.closeBGImage;
    _ivCloseBG.backgroundColor = _config.closeBGColor;
    _ivCloseBG.clipsToBounds = YES;
    _ivCloseBG.layer.cornerRadius = _config.closeBGImageCornerRadius < 0 ?  _const_ivCloseBGWidth.constant / 2 : _config.closeBGImageCornerRadius;
}

- (void)setupFloatingViewIfNeed{
    if(!_window.floatingView){
        _window.hidden = NO;
        UIView *floatingView = _config.floatingView;
        floatingView.userInteractionEnabled = YES;
        [self.view addSubview:floatingView];
        _window.floatingView = floatingView;
        JCPanGestureRecognizer *gr = [[JCPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
        gr.pressDelegate = self;
        [_window.floatingView addGestureRecognizer:gr];
        [self.view bringSubviewToFront:_closeBaseView];
        
        CGPoint initFloatingViewPosition = floatingView.frame.origin;
        if(_config.stickyToEdge){
            _closestEdge = [self closestEdgeForPoint:initFloatingViewPosition];
            switch (_closestEdge) {
                case JCFoatingViewClosestEdgeLeft:
                    initFloatingViewPosition.x = [self floatingViewMinX];
                    break;
                    
                case JCFoatingViewClosestEdgeTop:
                    initFloatingViewPosition.y = [self floatingViewMinY];
                    break;
                    
                case JCFoatingViewClosestEdgeRight:
                    initFloatingViewPosition.x = [self floatingViewMaxX];
                    break;
                    
                case JCFoatingViewClosestEdgeBottom:
                    initFloatingViewPosition.y = [self floatingViewMaxY];
                    break;
                    
                case JCFoatingViewClosestEdgeUnknown:
                    break;
            }
        }
        
        switch (_config.enterFrom) {
            case JCFoatingViewEnterFromLeft:
                floatingView.x = -floatingView.width;
                break;
                
            case JCFoatingViewEnterFromTop:
                floatingView.y = -floatingView.height;
                break;
                
            case JCFoatingViewEnterFromRight:
                floatingView.x = [JCUtils screenWidth];
                break;
                
            case JCFoatingViewEnterFromBottom:
                floatingView.y = [JCUtils screenHeight];
                break;
        }
        
        [UIView springAnimation:^{
            floatingView.x = initFloatingViewPosition.x;
            floatingView.y = initFloatingViewPosition.y;
        } completion:^(BOOL finished) {
            self.floatingViewLatestKnownPosition = initFloatingViewPosition;
        }];
    }
}

- (CGFloat)floatingViewMinX{
    return [JCUtils safeMarginLeft] - _config.overMargin;
}

- (CGFloat)floatingViewMaxX{
    return [JCUtils screenWidth] - [JCUtils safeMarginRight] - _window.floatingView.width + _config.overMargin;
}

- (CGFloat)floatingViewMinY{
    return [JCUtils safeMarginTop] - _config.overMargin;
}

- (CGFloat)floatingViewMaxY{
    return [JCUtils screenHeight] - [JCUtils safeMarginBottom] - _window.floatingView.height + _config.overMargin;
}

- (JCFoatingViewClosestEdge)closestEdgeForPoint:(CGPoint)point{
    JCFoatingViewClosestEdge closestEdge = JCFoatingViewClosestEdgeUnknown;
    CGFloat edgeDistanceLeft = point.x;
    CGFloat edgeDistanceTop = point.y;
    CGFloat edgeDistanceRight = [JCUtils screenWidth] - [JCUtils safeMarginRight] - point.x;
    CGFloat edgeDistanceBottom = [JCUtils screenHeight] - [JCUtils safeMarginBottom] - point.y;
    NSNumber *minNumber = [@[@(edgeDistanceLeft),
                             @(edgeDistanceTop),
                             @(edgeDistanceRight),
                             @(edgeDistanceBottom)]
                           valueForKeyPath:@"@min.self"];
    if(minNumber.doubleValue == edgeDistanceLeft){
        closestEdge = JCFoatingViewClosestEdgeLeft;
    }
    else if(minNumber.doubleValue == edgeDistanceTop){
        closestEdge = JCFoatingViewClosestEdgeTop;
    }
    else if(minNumber.doubleValue == edgeDistanceRight){
        closestEdge = JCFoatingViewClosestEdgeRight;
    }
    else if(minNumber.doubleValue == edgeDistanceBottom){
        closestEdge = JCFoatingViewClosestEdgeBottom;
    }
    
    return closestEdge;
}

#pragma mark - show/hide
- (void)showFloatingView{
    if(!_window.floatingView){
        _isShowing = YES;
        [self setupCloseView];
        [self setupFloatingViewIfNeed];
    }
    else{
        [self animateFloatingViewWithShow:YES];
    }
}

- (void)hideFloatingView{
    [self animateFloatingViewWithShow:NO];
}

- (void)animateFloatingViewWithShow:(BOOL)isShow{
    if(isShow){
        self.window.hidden = !isShow;
    }
    _isShowing = isShow;
    UIView *floatingView = _window.floatingView;
    CGFloat finalX = _floatingViewLatestKnownPosition.x;
    CGFloat finalY = _floatingViewLatestKnownPosition.y;
    
    switch (_closestEdge) {
        case JCFoatingViewClosestEdgeLeft:
            finalX = isShow ? _floatingViewLatestKnownPosition.x : -floatingView.width;
            break;
    
        case JCFoatingViewClosestEdgeTop:
            finalY = isShow ? _floatingViewLatestKnownPosition.y : -floatingView.height;
            break;
            
        case JCFoatingViewClosestEdgeRight:
            finalX = isShow ? _floatingViewLatestKnownPosition.x : [JCUtils screenWidth];
            break;
            
        case JCFoatingViewClosestEdgeBottom:
            finalY = isShow ? _floatingViewLatestKnownPosition.y : [JCUtils screenHeight];
            break;
            
        case JCFoatingViewClosestEdgeUnknown:
            break;
    }
    
    [UIView springAnimation:^{
        floatingView.x = finalX;
        floatingView.y = finalY;
    } completion:^(BOOL finished) {
        if(!isShow){
            self.window.hidden = !isShow;
        }
    }];
}

- (void)dismissFloatingView{
    [_window reset];
    [_config reset];
    _window.hidden = YES;
    _isShowing = NO;
}


#pragma mark - rotation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if(self.window.floatingView){
            [self handleFloatingViewRotation];
        }
    }];
}

- (void)handleFloatingViewRotation{
    CGFloat finalX = _window.floatingView.x;
    CGFloat finalY = _window.floatingView.y;
    
    switch (_closestEdge) {
        case JCFoatingViewClosestEdgeLeft:
            finalX = [self floatingViewMinX];
            break;
            
        case JCFoatingViewClosestEdgeTop:
            finalY = [self floatingViewMinY];
            break;
            
        case JCFoatingViewClosestEdgeRight:
            finalX = [self floatingViewMaxX];
            break;
            
        case JCFoatingViewClosestEdgeBottom:
            finalY = [self floatingViewMaxY];
            break;
            
        case JCFoatingViewClosestEdgeUnknown:
            break;
    }
    
    _window.floatingView.x = finalX;
    _window.floatingView.y = finalY;
    [self finaliseFloatingViewWithVelocity:CGPointZero animated:NO];
    [self setupCloseView];
}


#pragma mark - JCPanGestureRecognizerPressDelegate
- (void)didPress:(JCPanGestureRecognizer *)panGestureRecognizer{
    _window.floatingView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
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
    
    if(panGesture.state == UIGestureRecognizerStateChanged){
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
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedFloatingView:)]){
        [_delegate didClickedFloatingView:self];
    }
}

#pragma mark - drag effect
- (void)showCloseView:(BOOL)isShow{
    _const_closeViewHeight.constant = isShow ? _closeViewHeight : 0;
    
    [UIView springAnimation:^{
        [self.view layoutIfNeeded];
    } completion:nil];
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
        [UIView springAnimation:^{
            self.window.floatingView.center = newFloatingViewCenter;
            self.ivCloseBG.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        } completion:nil];
    }
}

- (void)finaliseFloatingViewWithVelocity:(CGPoint)velocity animated:(BOOL)animated{
    UIView *floatingView = _window.floatingView;
    CGFloat velocityX = 0.02 * velocity.x;
    CGFloat velocityY = 0.02 * velocity.y;
    
    CGFloat finalX = floatingView.x + velocityX;
    CGFloat finalY = floatingView.y + velocityY;
    
    if(_config.stickyToEdge){
        _closestEdge = [self closestEdgeForPoint:floatingView.center];
        switch (_closestEdge) {
            case JCFoatingViewClosestEdgeLeft:
                finalX = [self floatingViewMinX];
                break;
                
            case JCFoatingViewClosestEdgeTop:
                finalY = [self floatingViewMinY];
                break;
                
            case JCFoatingViewClosestEdgeRight:
                finalX = [self floatingViewMaxX];
                break;
                
            case JCFoatingViewClosestEdgeBottom:
                finalY = [self floatingViewMaxY];
                break;
                
            case JCFoatingViewClosestEdgeUnknown:
                break;
        }
    }
    else{
        if(finalX < [self floatingViewMinX]){
            finalX = [self floatingViewMinX];
        }
        else if(finalX > [self floatingViewMaxX]){
            finalX = [self floatingViewMaxX];
        }
        
        if(finalY < [self floatingViewMinY]){
            finalY = [self floatingViewMinY];
        }
        else if(finalY > [self floatingViewMaxY]){
            finalY = [self floatingViewMaxY];
        }
        
        _closestEdge = [self closestEdgeForPoint:floatingView.center];
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
    _floatingViewLatestKnownPosition = CGPointMake(finalX, finalY);
}

- (BOOL)dismissFloatingViewIfNeed{
    BOOL dismissed = NO;
    
    if(_hasTriggerCloseAnimation){
        [self dismissFloatingView];
        dismissed = YES;
        if(_delegate && [_delegate respondsToSelector:@selector(didDismissFloatingView:)]){
            [_delegate didDismissFloatingView:self];
        }
    }
    
    return dismissed;
}

@end
