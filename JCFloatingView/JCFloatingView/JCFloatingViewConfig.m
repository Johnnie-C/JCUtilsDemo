//
//  JCFloatingViewConfig.m
//  JCFloatingView
//
//  Created by Johnnie Cheng on 20/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCFloatingViewConfig.h"
#import <JCFramework/JCFramework.h>

@interface JCFloatingViewConfig()

@property (nonatomic, assign) BOOL hasCustomerFloatingView;
@property (nonatomic, assign) CGPoint initFloatingViewPosition;

@end





@implementation JCFloatingViewConfig

- (instancetype)init{
    if(self = [super init]){
        [self setupDefaulVaule];
    }
    
    return self;
}

- (void)setupDefaulVaule{
    _preferredStatusBarStyle = UIStatusBarStyleLightContent;
    _stickyToEdge = YES;
    _overMargin = 0;
    
    _floatingViewWidth = 60;
    _floatingViewHeight = 60;
    _floatingViewImage = [UIImage imageNamed:@"placeholder" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    _floatingViewBorderColor = [UIColor cancelRed];
    _floatingViewBorderWidth = 2.0f;
    _floatingViewCornerRadius = 30;
    _floatingView = [self defaultFloatingView];
    
    _closeImage = [UIImage imageNamed:@"ic_close" inBundle:[JCUtils frameworkBundle] compatibleWithTraitCollection:nil];
    _closeImageWidth = 20;
    _closeImageHeight = 20;
    _closeImageCornerRadius = 0;
    
    _closeBGImage = nil;
    _closeBGColor = [[UIColor cancelRed] colorWithAlphaComponent:0.8];
    _closeBGImageWidth = 40;
    _closeBGImageHeight = 40;
    _closeBGImageCornerRadius = -1;//will be regarded as _closeImageSize / 2 when render view
    
    _closeViewGradientColors = @[(id)[UIColor clearColor].CGColor, (id)[[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor];
    _closeViewGradientColorsLocations = @[@(0.0), @(0.5)];
    
    _enterFrom = JCFoatingViewEnterFromRight;
}

- (UIView *)defaultFloatingView{
    UIImageView *iv = [UIImageView new];
    [self configFloatingViewFrame];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.layer.cornerRadius = _floatingViewCornerRadius;
    iv.image = _floatingViewImage;
    iv.layer.cornerRadius = _floatingViewCornerRadius;
    iv.layer.borderColor = _floatingViewBorderColor.CGColor;
    iv.layer.borderWidth = _floatingViewBorderWidth;
    
    return iv;
}

- (void)configFloatingViewFrame{
    CGFloat x = _floatingViewInitPositionX > 0 ? _floatingViewInitPositionX : [JCUtils screenWidth] - _floatingViewWidth - [JCUtils safeMarginRight] + _overMargin;
    CGFloat y = _floatingViewInitPositionY > 0 ? _floatingViewInitPositionX : [JCUtils screenHeight] - _floatingViewHeight - [JCUtils safeMarginBottom];
    
    _floatingView.frame = CGRectMake(x, y, _floatingViewWidth, _floatingViewHeight);
    _initFloatingViewPosition = _floatingView.center;
}

- (void)setFloatingView:(UIView *)floatingView{
    _floatingView = floatingView;
    _initFloatingViewPosition = _floatingView.center;
    _hasCustomerFloatingView = YES;
}

- (void)setFloatingViewWidth:(CGFloat)width{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewWidth = width;
    [self configFloatingViewFrame];
}

- (void)setFloatingViewHeight:(CGFloat)height{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewHeight = height;
    [self configFloatingViewFrame];
}

- (void)setFloatingViewInitPositionX:(CGFloat)x{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewInitPositionX = x;
    [self configFloatingViewFrame];
}

- (void)setFloatingViewInitPositionY:(CGFloat)y{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewInitPositionY = y;
    [self configFloatingViewFrame];
}

- (void)setOverMargin:(CGFloat)margin{
    if(_hasCustomerFloatingView) return;
    
    _overMargin = margin;
    [self configFloatingViewFrame];
}

- (void)setFloatingViewImage:(UIImage *)image{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewImage = image;
    if([_floatingView isKindOfClass:[UIImageView class]]){
        ((UIImageView *)_floatingView).image = image;
    }
}

- (void)setFloatingViewCornerRadius:(CGFloat)cornerRadius{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewCornerRadius = cornerRadius;
    _floatingView.layer.cornerRadius = _floatingViewCornerRadius;
}

- (void)setFloatingViewBorderColor:(UIColor *)color{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewBorderColor = color;
    _floatingView.layer.borderColor = _floatingViewBorderColor.CGColor;
}

- (void)setFloatingViewBorderWidth:(CGFloat)width{
    if(_hasCustomerFloatingView) return;
    
    _floatingViewBorderWidth = width;
    _floatingView.layer.borderWidth = _floatingViewBorderWidth;
}

- (void)reset{
    _floatingView.center = _initFloatingViewPosition;
}

@end
