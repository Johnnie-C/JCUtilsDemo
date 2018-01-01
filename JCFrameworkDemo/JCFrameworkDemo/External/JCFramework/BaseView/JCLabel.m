//
//  JCLabel.m
//  Wendys_iOS
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "JCLabel.h"

#import "UIFont+JCUtils.h"

@implementation JCLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self setupFont];
    }
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupFont];
}

- (void)setupFont{
    self.font = [self.font convertToCustmerFont];
}

@end
