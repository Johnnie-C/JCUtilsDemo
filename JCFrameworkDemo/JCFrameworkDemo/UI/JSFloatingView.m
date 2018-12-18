//
//  JSFloatingView.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JSFloatingView.h"
#import "UIView+JCUtils.h"
#import "JCUtils.h"

@implementation JSFloatingView

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGFloat width = 80;
    CGFloat height = 110;
    
    [self.view setX:[JCUtils screenWidth] - width - [JCUtils safeMarginRight]];
    [self.view setY:[JCUtils screenHeight] - height - [JCUtils safeMarginBottom]];
    [self.view setWidth:width];
    [self.view setHeight:height];
    
    UIImageView *iv = [UIImageView new];
    [self.view addSubview:iv];
    [iv fillInSuperView];
    iv.image = [UIImage imageNamed:@"demo_image.jpeg"];
}

@end
