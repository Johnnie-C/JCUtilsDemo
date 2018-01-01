//
//  JCButton.m
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "JCButton.h"
#import "UIFont+JCUtils.h"

@implementation JCButton

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
    self.titleLabel.font = [self.titleLabel.font convertToCustmerFont];
}

@end
