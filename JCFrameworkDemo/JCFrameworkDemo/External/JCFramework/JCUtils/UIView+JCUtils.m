//
//  UIView+PFUtils.m
//  
//
//  Created by Chris Drake on 4/08/15.
//  Copyright (c) 2015 Moa Creative. All rights reserved.
//

#import "UIView+JCUtils.h"
#import "JCUtils.h"

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

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners{
    [self roundCornerWithRadius:cornerRadius corners:corners frame:self.bounds];
}

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners frame:(CGRect)frame{
    UIBezierPath *btnLatestMaskPath = [UIBezierPath
                                       bezierPathWithRoundedRect:frame
                                       byRoundingCorners:corners
                                       cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
                                       ];
    CAShapeLayer *btnLatestMaskLayer = [CAShapeLayer layer];
    btnLatestMaskLayer.frame = frame;
    btnLatestMaskLayer.path = btnLatestMaskPath.CGPath;
    self.layer.mask = btnLatestMaskLayer;
}

- (void)fillInSuperView{
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
}

- (void)addHeightConstraint:(CGFloat)height{
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
}

- (void)alignParentTopFillWidth{
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
}

- (void)alignParentBottomFillWidth{
    [self alignParentBottomFillWidthWithPaddingLeft:0 right:0];
}

- (void)alignParentBottomFillWidthWithPaddingLeft:(CGFloat)left right:(CGFloat)right{
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
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.superview
                               attribute:NSLayoutAttributeBottom
                               multiplier:1.0f
                               constant:0.f];
    
    [self.superview addConstraints:@[leading, bottom, trailing]];
}

@end
