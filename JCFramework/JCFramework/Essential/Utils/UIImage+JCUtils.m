//
//  UIImage+JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "UIImage+JCUtils.h"
#import "UIColor+JCUtils.h"

@implementation UIImage (JCUtils)

+ (UIImage *)originalImageNamed:(NSString *)imageName{
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)placeholderImage{
    return [UIImage imageNamed:@"image_placeholder"];
}

- (BOOL)isTransparentAt:(CGPoint)point{
    UIColor *color = [self colorAtPixel:point];
    CGFloat alphs = CGColorGetAlpha(color.CGColor);
    if (alphs > 0.0){
        return NO;
    }
    else{
        return YES;
    }
}

- (UIColor *)colorAtPixel:(CGPoint)point{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }

    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);

    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);

    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect=CGRectMake(0,0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageWithScaled:(CGFloat)scale {
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizeWithWidth:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *processImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *data = UIImageJPEGRepresentation(processImage, 1.f); //have to turn it into  a JPEG
    return [UIImage imageWithData:data];
}

- (UIImage *)rotateForExif {
    int kMaxResolution = INT_MAX; // Or whatever
    CGImageRef imgRef = self.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *newImageData = UIImageJPEGRepresentation(imageCopy, 1.0f);
    return [UIImage imageWithData:newImageData];
}

- (UIImage *)fillWithColor:(UIColor *)fillColor{
    BOOL supressOtherWarnings = NO;

    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);

    CGRect imageRect = CGRectMake(0, 0, width, height);

    UIGraphicsBeginImageContext(imageRect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context,NO);
    CGContextSetAllowsAntialiasing( context ,NO );

    CGContextBeginTransparencyLayer(context, NULL);
    //Save current status of graphics context
    CGContextSaveGState(context);

    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, imageRect, nil);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef ctxt = CGBitmapContextCreate(rawData, width, height,
                                              bitsPerComponent, bytesPerRow, colorSpace,
                                              kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(ctxt, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(ctxt);

    //    RGBColor *backgroundRGBColor = [[RGBColor alloc] initWithColor:[UIColor clearColor]];
    RGBColor *foregroundColor = [[RGBColor alloc] initWithColor:fillColor];

    // Loop through all pixels
    for(int x = 0 ; x<width ; x++){
        for(int y = 0 ; y<height ; y++){
            NSInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;

            float red = (rawData[byteIndex]     * 1.0)/255.0f;
            float green = (rawData[byteIndex + 1] * 1.0)/255.0f;
            float blue = (rawData[byteIndex + 2] * 1.0)/255.0f;
            float alpha = (rawData[byteIndex + 3] * 1.0)/255.0f;

            UIColor *color;

            if(red == 1 && green == 1 && blue == 1 ) {
                // White
                color = [UIColor colorWithRed:foregroundColor.red green:foregroundColor.green blue:foregroundColor.blue alpha:alpha];
            } else if (alpha > 0 && (red + 10/255.0f) > green && (red - 10/255.0f) < green && (green + 10/255.0f) > blue && (green - 10/255.0f) < blue) {
                // Grayscale
                color = [UIColor colorWithRed:foregroundColor.red green:foregroundColor.green blue:foregroundColor.blue alpha:alpha];
                //                RGBColor *replacePixel = [self getColour:100*red between:@[[backgroundRGBColor color],[foregroundColor color]]];
                //                color = [UIColor colorWithRed:replacePixel.red green:replacePixel.green blue:replacePixel.blue alpha:alpha];
            } else if (alpha > 0) {
                // Other
                color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
                if(!supressOtherWarnings){
                    NSLog(@"MCTintedButton warning: Unidentified pixels detected in image. Pixels won't be changed");
                    supressOtherWarnings = YES;
                }
            }

            if (color != [UIColor clearColor] && color != nil){
                CGColorRef colorRef = [color CGColor];
                CGRect contextRect = CGRectMake(x,height-y,1,1);

                CGColorSpaceRef colorSpace = CGColorGetColorSpace(colorRef);
                CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
                const CGFloat *colors = CGColorGetComponents(colorRef);
                if (model == kCGColorSpaceModelMonochrome)
                    CGContextSetRGBFillColor(context, colors[0], colors[0], colors[0], colors[1]);
                else
                    CGContextSetRGBFillColor(context, colors[0], colors[1], colors[2], colors[3]);

                contextRect.size.height = -contextRect.size.height;
                CGContextFillRect(context, contextRect);
            }
        }
    }

    free(rawData);
    CGContextRestoreGState(context);
    CGContextEndTransparencyLayer(context);
    UIImage *blackWhiteLayer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    blackWhiteLayer = [UIImage imageWithCGImage:[blackWhiteLayer CGImage]
                                          scale:[self scale]
                                    orientation:(blackWhiteLayer.imageOrientation)];

    return blackWhiteLayer;
}
    
- (UIImage *)roundImage{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = self.size.width / 2;
    CGContextBeginPath (context);
    
    CGFloat imageCentreX = self.size.width / 2;
    CGFloat imageCentreY = self.size.height / 2;
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2 * M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
    
#pragma mark - Base64
- (NSString *)encodeToBase64String:(UIImage *)image{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
    
+ (UIImage *)fromBase64:(NSString *)strEncodeData{
    if(!strEncodeData) return nil;
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


@end


