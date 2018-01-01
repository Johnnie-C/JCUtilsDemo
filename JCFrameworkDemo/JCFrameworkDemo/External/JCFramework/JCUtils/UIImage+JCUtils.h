//
//  UIImage+JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (JCUtils)

+ (UIImage *)originalImageNamed:(NSString *)imageName;
+ (UIImage *)placeholderImage;

- (BOOL)isTransparentAt:(CGPoint)point;
- (UIColor *)colorAtPixel:(CGPoint)point;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageWithScaled:(CGFloat)scale ;
- (UIImage *)resizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)rotateForExif;
- (UIImage *)fillWithColor:(UIColor *)fillColor;

@end
