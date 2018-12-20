//
//  JCFloatingViewConfig.h
//  JCFloatingView
//
//  Created by Johnnie Cheng on 20/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JCFoatingViewEnter){
    JCFoatingViewEnterFromLeft,
    JCFoatingViewEnterFromTop,
    JCFoatingViewEnterFromRight,
    JCFoatingViewEnterFromBottom
};




@interface JCFloatingViewConfig : NSObject

@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;
@property (nonatomic, assign) BOOL stickyToEdge;
@property (nonatomic, assign) CGFloat overMargin;

//if a customer floating view is set, following propert will be ignored:
//floatingViewImage, floatingViewCornerRadius, floatingViewCornerRadius, floatingViewBorderColor, floatingViewBorderWidth
@property (nonatomic, strong) UIView *floatingView;
@property (nonatomic, assign) CGFloat floatingViewInitPositionX;
@property (nonatomic, assign) CGFloat floatingViewInitPositionY;
@property (nonatomic, assign) CGFloat floatingViewWidth;
@property (nonatomic, assign) CGFloat floatingViewHeight;
@property (nonatomic, strong) UIImage *floatingViewImage;
@property (nonatomic, strong) UIColor *floatingViewBorderColor;
@property (nonatomic, assign) CGFloat floatingViewBorderWidth;
@property (nonatomic, assign) CGFloat floatingViewCornerRadius;

@property (nonatomic, strong) NSArray *closeViewGradientColors;//top to bottom
@property (nonatomic, strong) NSArray *closeViewGradientColorsLocations;//top to bottom

@property (nonatomic, assign) CGFloat closeImageWidth;
@property (nonatomic, assign) CGFloat closeImageHeight;
@property (nonatomic, strong) UIImage *closeImage;
@property (nonatomic, assign) CGFloat closeImageCornerRadius;

@property (nonatomic, assign) CGFloat closeBGImageWidth;
@property (nonatomic, assign) CGFloat closeBGImageHeight;
@property (nonatomic, strong) UIImage *closeBGImage;
@property (nonatomic, strong) UIColor *closeBGColor;
@property (nonatomic, assign) CGFloat closeBGImageCornerRadius;

@property (nonatomic, assign) JCFoatingViewEnter enterFrom;

- (void)reset;

@end

