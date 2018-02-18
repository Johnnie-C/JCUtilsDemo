//
//  JCHomeBaseCell.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 18/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCHomeBaseCell.h"

#import "JCUtils.h"
#import "UIFont+JCUtils.h"

@implementation JCHomeBaseCell

- (void)updateUIWithTitle:(NSString *)title{
    [NSException raise:@"Unimplemented!" format:@"updateUIWithTitle: must be implemented in child class"];
}

+ (CGFloat)heightForCellWithTitle:(NSString *)title{
    CGFloat labelHeight = [title
                           boundingRectWithSize:CGSizeMake([JCUtils screenWidth] - 40, 0)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                                        NSFontAttributeName : [UIFont fontWithType:JCFontTypeRegular size:17]
                                        }
                           context:nil].size.height;
    
    return MAX(labelHeight + 24 /*top, bottom matgin*/, 60);
}

@end
