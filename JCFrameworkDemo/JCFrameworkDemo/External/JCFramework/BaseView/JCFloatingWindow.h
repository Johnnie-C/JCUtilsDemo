//
//  JCFloatingWindow.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCFloatingWindow : UIWindow

@property (nonatomic, strong) UIView *floatingView;

- (void)reset;

@end
