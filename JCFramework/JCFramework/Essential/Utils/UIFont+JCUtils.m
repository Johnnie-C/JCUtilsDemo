//
//  UIFont+JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "UIFont+JCUtils.h"
#import "NSString+JCUtils.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation UIFont (JCUtils)
  
+ (void)registerFontWithFilename:(NSString *)filename bundle:(NSBundle *)bundle{
    NSString *pathForResourceString = [bundle pathForResource:filename ofType:nil];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([pathForResourceString UTF8String]);
    CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(customFont, &error);
    CGFontRelease(customFont);
}
  
+ (void)loadFontsWithFilenames:(NSArray<NSString *> *)filenames bundle:(NSBundle *)bundle{
    for(NSString *filename in filenames){
        [UIFont registerFontWithFilename:filename bundle:bundle];
    }
}


+ (UIFont *)fontWithType:(JCFontType)type{
    return [UIFont fontWithType:type size:17]; // default font size
}

+ (UIFont *)fontWithSize:(CGFloat)size{
    return [UIFont fontWithType:JCFontTypeRegular size:size]; // default font size
}

+ (UIFont *)fontWithType:(JCFontType)type size:(CGFloat)size{
    switch (type){
        case JCFontTypeLight:
            return [UIFont fontWithName:@"Helvetica-Light" size:size];
            
        case JCFontTypeBold:
            return [UIFont fontWithName:@"Helvetica-Bold" size:size];
            
        case JCFontTypeItalic:
            return [UIFont fontWithName:@"Helvetica-Oblique" size:size];
            
        case JCFontTypeRegular:
        default:
            return [UIFont fontWithName:@"Helvetica" size:size];
    }
}

- (UIFont *)convertToCustmerFont{
    UIFont *customerFont;
    if([self.fontName containsString:@"Bold"]){
        customerFont = [UIFont fontWithType:JCFontTypeBold size:self.pointSize];
    }
    else if([self.fontName containsString:@"Light"]){
        customerFont = [UIFont fontWithType:JCFontTypeLight size:self.pointSize];
    }
    else if([self.fontName containsString:@"Italic"]){
        customerFont = [UIFont fontWithType:JCFontTypeItalic size:self.pointSize];
    }
    
    if(!customerFont){
        customerFont = [UIFont fontWithSize:self.pointSize];
    }
    
    return customerFont;
}

@end
