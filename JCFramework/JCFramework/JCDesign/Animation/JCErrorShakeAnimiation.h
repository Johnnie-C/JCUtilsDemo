//
//  JCErrorShakeAnimiation.h
//
//  Created by Johnnie on 5/03/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCErrorShakeAnimiation : CABasicAnimation

+ (instancetype)animationOnView:(UIView *)view;
- (void)animate;

@end
