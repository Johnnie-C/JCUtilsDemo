//
//  JCTextField.m
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "JCTextField.h"
#import "UIFont+JCUtils.h"

@implementation JCTextField

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
