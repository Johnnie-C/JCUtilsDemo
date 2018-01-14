//
//  JCParabolaAnimationHandler.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 14/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^JCParabloaAnimationCompletion)(void);

@interface JCParabolaAnimationHandler : NSObject<CAAnimationDelegate>

@property (assign, nonatomic) CGFloat duration;

-(void)startAnimationandView:(UIView *)view
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint endSize:(CGSize)endSize
               complemention:(JCParabloaAnimationCompletion)completion;

@end
