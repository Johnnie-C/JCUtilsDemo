//
//  UIView+PFUtils.h
//  
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JC_CONST_BOTTOM;
extern NSString *const JC_CONST_TOP;
extern NSString *const JC_CONST_LEFT;
extern NSString *const JC_CONST_RIGHT;
extern NSString *const JC_CONST_WIDTH;
extern NSString *const JC_CONST_HEIGHT;

@interface UIView (JCUtils)

+ (instancetype)initFromNib;
+ (instancetype)initFromNib:(CGRect)frame;

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;

- (void)removeAllSubviews;


- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)right;
- (CGFloat)bottom;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;

- (CGRect)rectInView:(UIView *)view;
- (CGPoint)centerInView:(UIView *)view;

- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;
- (void)roundCornerWithRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners frame:(CGRect)frame;

- (NSDictionary *)fillInSuperView;
- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)height;
- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)width;
- (NSLayoutConstraint *)addTopConstraintToParent:(CGFloat)top;
- (NSLayoutConstraint *)addLeftConstraintToParent:(CGFloat)left;
- (NSLayoutConstraint *)addRightConstraintToParent:(CGFloat)right;
- (NSLayoutConstraint *)addBottomConstraintToParent:(CGFloat)bottom;
- (NSLayoutConstraint *)addCenterVerticalConstraintWithOffset:(CGFloat)offset;
- (NSLayoutConstraint *)addCenterHorizontalConstraintWithOffset:(CGFloat)offset;


/**
 use JC_CONST_BOTTOM or similar constant as key
 */
- (NSDictionary *)alignParentTopFillWidth;
- (NSDictionary *)alignParentBottomFillWidth;
- (NSDictionary *)alignParentBottomFillWidthWithPaddingLeft:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom;


+ (void)springAnimation:(void (^)(void))animation completion:(void (^ __nullable)(BOOL finished))completion;

@end

