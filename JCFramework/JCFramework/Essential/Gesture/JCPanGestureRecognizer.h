//
//  JCPanGestureRecognizer.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 19/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCPanGestureRecognizer;
@protocol JCPanGestureRecognizerPressDelegate <NSObject>

- (void)didPress:(JCPanGestureRecognizer *)panGestureRecognizer;

@end





@interface JCPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) NSObject<JCPanGestureRecognizerPressDelegate> *pressDelegate;

- (BOOL)isTap;

@end
