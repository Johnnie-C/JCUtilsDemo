//
//  UIView+PFUtils.m
//  
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "UIView+JCUtils.h"
#import "JCUtils.h"

NSString *const JC_CONST_BOTTOM = @"jc_constBottom";
NSString *const JC_CONST_TOP = @"jc_constTop";
NSString *const JC_CONST_LEFT = @"jc_constLeft";
NSString *const JC_CONST_RIGHT = @"jc_constRight";
NSString *const JC_CONST_WIDTH = @"jc_constWdith";
NSString *const JC_CONST_HEIGHT = @"jc_constHeight";

@implementation UIView (JCUtils)

+ (instancetype)initFromNib {
    Class class = [self class];
    return [UIView loadNibNamed:NSStringFromClass(class)
                        ofClass:class];
}

+ (instancetype)initFromNib:(CGRect)frame {
    id instance = [self initFromNib];
    if(self) {
        [instance setFrame:frame];
    }
    return instance;
}

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass {
    if (nibName && objClass) {
        NSArray *objects = [[JCUtils frameworkBundle] loadNibNamed:nibName owner:nil options:nil];
        for (id currentObject in objects){
            if ([currentObject isKindOfClass:objClass]) {
                return currentObject;
            }
        }
    }
    
    return nil;
}

- (void)removeAllSubviews {
    NSArray *views = [self subviews];
    for (UIView *v in views) {
        [v removeFromSuperview];
    }
}

- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    [self setFrame:newFrame];
}


- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)right{
    return self.frame.origin.x + [self width];
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGRect)rectInView:(UIView *)view{
    return self.superview ? [self.superview convertRect:self.frame toView:view] : CGRectZero;
}

- (CGPoint)centerInView:(UIView *)view{
    CGRect rect = [self rectInView:view];
    if(CGRectEqualToRect(rect, CGRectZero)){
        return CGPointZero;
    }
    
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners{
    [self roundCornerWithRadius:cornerRadius corners:corners frame:self.bounds];
}

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners frame:(CGRect)frame{
    self.clipsToBounds = YES;
    UIBezierPath *btnLatestMaskPath = [UIBezierPath
                                       bezierPathWithRoundedRect:frame
                                       byRoundingCorners:corners
                                       cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *btnLatestMaskLayer = [CAShapeLayer layer];
    btnLatestMaskLayer.frame = frame;
    btnLatestMaskLayer.path = btnLatestMaskPath.CGPath;
    self.layer.mask = btnLatestMaskLayer;
}

- (NSDictionary *)fillInSuperView{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.superview
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:1.0f
                                 constant:0.f];
    
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.superview
                                  attribute:NSLayoutAttributeHeight
                                  multiplier:1.0f
                                  constant:0.f];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    
    [self.superview addConstraints:@[top, leading, width, height]];
    
    return @{
             JC_CONST_TOP : top,
             JC_CONST_LEFT : leading,
             JC_CONST_WIDTH : width,
             JC_CONST_HEIGHT : height
             };
}

- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)height{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:height];
    [self addConstraint:heightConstraint];
    
    return heightConstraint;
}

- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)width{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *widthConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:width];
    [self addConstraint:widthConstraint];
    
    return widthConstraint;
}

- (NSLayoutConstraint *)addCenterVerticalConstraintWithOffset:(CGFloat)offset{
    NSLayoutConstraint *yCenterConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:offset];
    [self.superview addConstraint:yCenterConstraint];
    
    return yCenterConstraint;
}

- (NSLayoutConstraint *)addCenterHorizontalConstraintWithOffset:(CGFloat)offset{
    NSLayoutConstraint *xCenterConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:offset];
    [self.superview addConstraint:xCenterConstraint];
    
    return xCenterConstraint;
}

- (NSLayoutConstraint *)addTopConstraintToParent:(CGFloat)top{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint
                                         constraintWithItem:self
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.superview
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0f
                                         constant:top];
    [self.superview addConstraint:topConstraint];
    
    return topConstraint;
}

- (NSLayoutConstraint *)addLeftConstraintToParent:(CGFloat)left{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:left];
    [self.superview addConstraint:leading];
    
    return leading;
}

- (NSLayoutConstraint *)addRightConstraintToParent:(CGFloat)right{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:-right];
    [self.superview addConstraint:trailing];
    
    return trailing;
}

- (NSLayoutConstraint *)addBottomConstraintToParent:(CGFloat)bottom{
    NSLayoutConstraint *bottomConst = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.superview
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                       constant:-bottom];
    
    [self.superview addConstraint:bottomConst];
    
    
    return bottomConst;
}

- (NSDictionary *)alignParentTopFillWidth{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:0.f];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    
    [self.superview addConstraints:@[leading, top, trailing]];
    
    return @{
             JC_CONST_TOP : top,
             JC_CONST_LEFT : leading,
             JC_CONST_RIGHT : trailing
             };
}

- (NSDictionary *)alignParentBottomFillWidth{
    return [self alignParentBottomFillWidthWithPaddingLeft:0 right:0 bottom :0];
}

- (NSDictionary *)alignParentBottomFillWidthWithPaddingLeft:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0f
                                    constant:-right];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:left];
    
    NSLayoutConstraint *bottomConst = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.superview
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                       constant:-bottom];
    
    [self.superview addConstraints:@[leading, bottomConst, trailing]];
    
    return @{
             JC_CONST_BOTTOM : bottomConst,
             JC_CONST_LEFT : leading,
             JC_CONST_RIGHT : trailing
             };
}

@end

