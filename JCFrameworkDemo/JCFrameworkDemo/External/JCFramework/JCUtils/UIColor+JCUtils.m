//
//  UIColor+JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "UIColor+JCUtils.h"

@implementation UIColor (JCUtils)

+ (UIColor *) colorWithHex:(NSString *)hexString {
    
    if (!hexString)
        return nil;
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSString *)hexStringFromColor
{
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r, g, b;
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
    }
    else if (colorSpace == kCGColorSpaceModelRGB) {
        r = components[0];
        g = components[1];
        b = components[2];
    }
    
    NSString *hex = [NSString stringWithFormat:@"%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255)];
    return hex;
}

- (UIColor *)lighterColor {
    return [self colorWithScale:1.2];
}

- (UIColor *)darkerColor {
    return [self colorWithScale:0.8];
}

- (UIColor *)colorWithScale:(CGFloat)scale {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * scale
                               alpha:a];
    return nil;
}

+ (UIColor *)getColour:(double)pct between:(NSArray *)colors defaultColor:(UIColor *)defaultColor{
    NSInteger count = [colors count];
    
    if(count == 1)
        return [colors objectAtIndex:0];
    
    int pos1, pos2;
    float red, green, blue;
    NSInteger segments = count - 1;
    int segmentSize = 100/segments;
    
    pos2 = ceil(MAX(pct,0.01)/segmentSize);
    pos1 = pos2 - 1;
    
    pct = (pct-pos1*segmentSize)/(pos2*segmentSize-pos1*segmentSize);
    
    UIColor *col1 = [colors objectAtIndex:pos1];
    UIColor *col2 = [colors objectAtIndex:pos2];
    if(col1 == [UIColor clearColor])
        col1 = defaultColor;
    if(col2 == [UIColor clearColor])
        col2 = defaultColor;
    
    RGBColor *color1 = [[RGBColor alloc] initWithColor:col1];
    RGBColor *color2 = [[RGBColor alloc] initWithColor:col2];
    red = color1.red * (1-pct) + color2.red * pct;
    green = color1.green * (1-pct) + color2.green * pct;
    blue = color1.blue * (1-pct) + color2.blue * pct;
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end





#pragma mark - RGBColor
@implementation RGBColor

@synthesize red, green, blue, alpha, color;
- (id)initWithColor:(UIColor *)uiColor
{
    self = [super init];
    if (self) {
        CGColorRef colorRef = [uiColor CGColor];
        
        CGColorSpaceRef colorSpace = CGColorGetColorSpace(colorRef);
        CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
        const CGFloat *colors = CGColorGetComponents(colorRef);
        
        if (model == kCGColorSpaceModelMonochrome) {
            red = colors[0];
            green = colors[0];
            blue = colors[0];
            alpha = colors[1];
        } else {
            red = colors[0];
            green = colors[1];
            blue = colors[2];
            alpha = colors[3];
        }
        
        color = uiColor;
    }
    return self;
}

@end





#pragma mark - Custom Colors
@implementation UIColor (JCCustomise)
+ (UIColor *)appMainColor{
    return [UIColor colorWithRed:206.0/255.0 green:18.0/255.0 blue:39.0/255.0 alpha:1];
}

+ (UIColor *)appMainColorLight{
    return [UIColor colorWithRed:234.0/255.0 green:166.0/255.0 blue:174.0/255.0 alpha:1];
}

#pragma mark - loader
+ (UIColor *)loaderBG{
    return [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
}

#pragma mark - tabbar
+ (UIColor *)tabbarBackgroundColor{
    return [UIColor colorWithRed:39.0/255.0 green:30.0/255.0 blue:29.0/255.0 alpha:1.0];
}

+ (UIColor *)tabbarTitleColor{
    return nil;
}

+ (UIColor *)tabbarSelectedTitleColor{
    return [UIColor whiteColor];
}


#pragma mark - navigation bar
+ (UIColor *)navigationbarBackgroundColor{
    return [UIColor navigationbarBackgroundColorWithAlpha:1];
}

+ (UIColor *)navigationbarBackgroundColorWithAlpha:(CGFloat)alpha{
    return [[UIColor appMainColor] colorWithAlphaComponent:alpha];
}

+ (UIColor *)navigationbarIconColor{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationbarTextColor{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationbarTextHighlitColor{
    return [[UIColor navigationbarTextColor] darkerColor];
}

#pragma mark - toast
+ (UIColor *)toastMessageRed{
    return [UIColor colorWithRed:228.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0];
}

+ (UIColor *)toastMessageGreen{
    return [UIColor colorWithRed:60.0/255.0 green:180.0/255.0 blue:120.0/255.0 alpha:1.0];
}

+ (UIColor *)toastMessageOrange{
    return [UIColor colorWithRed:250.0/255.0 green:178.0/255.0 blue:80.0/255.0 alpha:1.0];
}

#pragma mark - other
+ (UIColor *)borderColor{
    return [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0];
}

+ (UIColor *)borderSelectedColor{
    return [UIColor colorWithRed:48.0/255.0 green:173.0/255.0 blue:230.0/255.0 alpha:1.0];
}

@end
