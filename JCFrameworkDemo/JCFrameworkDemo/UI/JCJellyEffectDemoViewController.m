//
//  JCJellyEffectDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 7/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCJellyEffectDemoViewController.h"


@interface JCJellyEffectDemoViewController ()

@property (weak, nonatomic) IBOutlet UIView *jellyView;
@property (strong, nonatomic) CAShapeLayer *jellyLayer;
@property (strong, nonatomic) UIView *controlPointView;//only used for spring animation
@property (assign, nonatomic) CGPoint controlPointCenter;
//@property (assign, nonatomic) CGPoint controlPointLeft;
//@property (assign, nonatomic) CGPoint controlPointRight;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL isAnimating;

@end





@implementation JCJellyEffectDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == _jellyView && [keyPath isEqualToString:@"bounds"]) {
        [self updateJellyLayerWithAllControllPoints:NO];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateJellyLayerWithAllControllPoints:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateJellyLayerWithAllControllPoints:NO];
}

- (void)setupView{
    [self setupNavBar];
    [self setupJellyView];
}

- (void)setupNavBar{
    self.title = @"Jelly Effect Demo";
    [self setLeftBarButtonType:LeftBarButtonTypeBack];
}

- (void)dealloc{
    [_jellyView removeObserver:self forKeyPath:@"bounds"];
}

- (void)setupJellyView{
    _controlPointView = [[UIView alloc] initWithFrame:CGRectMake(self.jellyView.width / 2, self.jellyView.height - 2.5, 5, 5)];
    [self.view addSubview:_controlPointView];
    _controlPointCenter = _controlPointView.center;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateControlPoint)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.paused = YES;
    
    [self updateJellyLayerWithAllControllPoints:NO];
    [self addDragGesture];
}

- (void)updateControlPoint{
    _controlPointCenter.x = _controlPointView.layer.presentationLayer.position.x;
    _controlPointCenter.y = _controlPointView.layer.presentationLayer.position.y;
    [self updateJellyLayerWithAllControllPoints:YES];
}

- (void)updateJellyLayerWithAllControllPoints:(BOOL)updateAllControllPoints{
    [_jellyLayer removeFromSuperlayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat totalWidth = self.jellyView.width;
    CGFloat xOffset = _controlPointCenter.x - totalWidth / 2;
    CGFloat absoluteY =  _controlPointCenter.y - _jellyView.bottom;
    
    CGFloat x = 0, y = 0;
    [path moveToPoint:CGPointMake(x, y)];//1
    
    x = totalWidth;
    [path addLineToPoint:CGPointMake(x, y)];//2
    
    y = self.jellyView.height;
    [path addLineToPoint:CGPointMake(x, y)];//3
    
    if(updateAllControllPoints){
        x -= totalWidth / 3 + xOffset;
        CGFloat rightControllPointXOffset = _controlPointCenter.x - x;
        CGFloat rightControllPointX = x - rightControllPointXOffset;
        [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(rightControllPointX, _jellyView.bottom - absoluteY)];//4
    }
    
    x -= updateAllControllPoints ? totalWidth / 3 + xOffset : totalWidth;
    [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:_controlPointCenter];//5
    
    if(updateAllControllPoints){
        CGFloat leftControllPointXOffset = _controlPointCenter.x - x;
        CGFloat leftControllPointX = x - leftControllPointXOffset;
        x = 0;
        [path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(leftControllPointX, _jellyView.bottom - absoluteY)];//6
    }
    
    y -= self.jellyView.height;
    [path addLineToPoint:CGPointMake(x, y)];//7
    
    [path setUsesEvenOddFillRule:YES];
    _jellyLayer = [CAShapeLayer layer];
    _jellyLayer.path = path.CGPath;
    _jellyLayer.fillRule = kCAFillRuleEvenOdd;
    _jellyLayer.fillColor = [UIColor appMainColor].CGColor;
    _jellyLayer.opacity = 1;
    
    [_jellyView.layer insertSublayer:_jellyLayer atIndex:0];
}

- (void)addDragGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanAction:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:pan];
}

- (void)handlePanAction:(UIPanGestureRecognizer *)pan
{
    if(!_isAnimating){
        if(pan.state == UIGestureRecognizerStateChanged)
        {
            CGPoint point = [pan translationInView:self.view];
            CGFloat contollPointX = _jellyView.width / 2 + point.x;
            CGFloat contollPointY = point.y * 0.7 + _jellyView.height;
            if(contollPointY > 2 * _jellyView.height){
                contollPointY = 2 * _jellyView.height;
            }
            [_controlPointView setX:contollPointX];
            [_controlPointView setY:contollPointY];
            _controlPointCenter.x = contollPointX;
            _controlPointCenter.y = contollPointY;
            [self updateJellyLayerWithAllControllPoints:NO];
            
        }
        else if (pan.state == UIGestureRecognizerStateCancelled ||
                 pan.state == UIGestureRecognizerStateEnded ||
                 pan.state == UIGestureRecognizerStateFailed)
        {
            _isAnimating = YES;
            _displayLink.paused = NO;
            
            [UIView animateWithDuration:0.4
                                  delay:0.0
                 usingSpringWithDamping:0.1
                  initialSpringVelocity:8
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [_controlPointView setX:self.jellyView.width / 2];
                                 [_controlPointView setY:self.jellyView.height - 2.5];
                                 
                             } completion:^(BOOL finished) {
                                 if(finished){
                                     _displayLink.paused = YES;
                                     _isAnimating = NO;
                                     [self updateControlPoint];
                                 }
                             }];
        }
    }
}

@end
