//
//  UIView+PFUtils.h
//  
//
//  Created by Chris Drake on 4/08/15.
//  Copyright (c) 2015 Moa Creative. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (JCUtils)

+ (instancetype)initFromNib;
+ (instancetype)initFromNib:(CGRect)frame;

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;

- (void)removeAllSubviews;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (CGFloat)x;

- (CGFloat)y;

- (CGFloat)width;

- (CGFloat)height;

- (CGFloat)right;

- (CGFloat)bottom;

- (void)setX:(CGFloat)x;

- (void)setY:(CGFloat)y;

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;
- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners frame:(CGRect)frame;

- (void)fillInSuperView;
- (void)addHeightConstraint:(CGFloat)height;
- (void)alignParentTopFillWidth;
- (void)alignParentBottomFillWidth;
- (void)alignParentBottomFillWidthWithPaddingLeft:(CGFloat)left right:(CGFloat)right;

@end
