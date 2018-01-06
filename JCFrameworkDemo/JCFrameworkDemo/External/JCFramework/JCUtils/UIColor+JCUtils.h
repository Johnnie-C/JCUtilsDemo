//
//  UIColor+JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(JCUtils)

+ (UIColor *) colorWithHex:(NSString *) hexString;
- (NSString *)hexStringFromColor;

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;
- (UIColor *)colorWithScale:(CGFloat)scale;

+ (UIColor *)getColour:(double)pct between:(NSArray *)colors defaultColor:(UIColor *)defaultColor;

@end





#pragma mark - Custom Colors
@interface UIColor(JCCustomise)
+ (UIColor *)appMainColor;
+ (UIColor *)appMainColorLight;

#pragma mark - loader
+ (UIColor *)loaderBG;

#pragma mark - tabbar
+ (UIColor *)tabbarBackgroundColor;
+ (UIColor *)tabbarTitleColor;
+ (UIColor *)tabbarSelectedTitleColor;

#pragma mark - navigation bar
+ (UIColor *)navigationbarBackgroundColor;
+ (UIColor *)navigationbarBackgroundColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)navigationbarIconColor;
+ (UIColor *)navigationbarTextColor;
+ (UIColor *)navigationbarTextHighlitColor;

#pragma mark - toast
+ (UIColor *)toastMessageRed;
+ (UIColor *)toastMessageGreen;
+ (UIColor *)toastMessageOrange;

#pragma mark - other
+ (UIColor *)borderColor;
+ (UIColor *)borderSelectedColor;

@end





@interface RGBColor : NSObject

@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat alpha;
@property UIColor *color;

- (id)initWithColor:(UIColor *)uiColor;

@end
