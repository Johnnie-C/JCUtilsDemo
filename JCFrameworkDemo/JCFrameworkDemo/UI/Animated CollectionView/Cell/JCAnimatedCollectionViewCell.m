//
//  JCAnimatedCollectionViewCell.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 10/02/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCAnimatedCollectionViewCell.h"

#import <JCFramework/JCFramework.h>

@implementation JCAnimatedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    UIColor *bgColor = [UIColor colorWithRed:16.0/255.0 green:186.0/255.0 blue:248.0/255.0 alpha:1];
    if(highlighted){
        bgColor = [bgColor darkerColor];
    }
    
    self.backgroundColor = bgColor;
}

@end
