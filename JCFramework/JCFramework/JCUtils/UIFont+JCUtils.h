//
//  UIFont+JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCFontType) {
    JCFontTypeRegular,
    JCFontTypeLight,
    JCFontTypeBold,
    JCFontTypeItalic
};


@interface UIFont (JCUtils)

+ (void)registerFontWithFilename:(NSString *)filename bundle:(NSBundle *)bundle;
+ (void)loadFontsWithFilenames:(NSArray<NSString *> *)filenames bunble:(NSBundle *)bundle;
  
+ (UIFont *)fontWithType:(JCFontType)type;
+ (UIFont *)fontWithSize:(CGFloat)size;
+ (UIFont *)fontWithType:(JCFontType)type size:(CGFloat)size;

- (UIFont *)convertToCustmerFont;

@end
