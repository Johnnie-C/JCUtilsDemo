//
//  JCFramework.h
//  JCUtils
//
//  Created by Johnnie Cheng on 20/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JCUtils.
FOUNDATION_EXPORT double JCUtilsVersionNumber;

//! Project version string for JCUtils.
FOUNDATION_EXPORT const unsigned char JCUtilsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JCUtils/PublicHeader.h>




#import "JCDragableCellGestureRecognizer.h"
#import "JCPanGestureRecognizer.h"

#import "JCUtils.h"
#import "NSArray+JCUtils.h"
#import "NSDictionary+JCUtils.h"
#import "NSString+JCUtils.h"
#import "UIColor+JCUtils.h"
#import "UIFont+JCUtils.h"
#import "UIImage+JCUtils.h"
#import "UINavigationBar+JCUtils.h"
#import "UIView+JCUtils.h"


//JCDesign
#if __has_include("JCDesign.h")
#import "JCDesign.h"
#endif

//JCAuthentiacation
#if __has_include("JCAuthentication.h")
#import "JCAuthentication.h"
#endif


//JCLocation
#if __has_include("JCLocationHelper.h")
#import "JCLocationHelper.h"
#endif

//JCAlert
#if __has_include("JCUIAlertUtils.h")
#import "JCUIAlertUtils.h"
#endif

//Device ID
#if __has_include("UIView+TouchHighlighting.h")
#import "UIView+TouchHighlighting.h"
#import "MTCompoundButton.h"
#endif

//JCToast
#if __has_include("JCToast.h")
#import "JCToast.h"
#endif

//JCUtils+Comprehansive
#if __has_include("JCUtils+Comprehansive.h")
#import "JCUtils+Comprehansive.h"
#endif

