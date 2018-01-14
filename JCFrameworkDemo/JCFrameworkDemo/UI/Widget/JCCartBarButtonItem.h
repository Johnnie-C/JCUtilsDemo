//
//  JCCartBarButtonItem.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 14/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCBarButtonItem.h"
#import "JCLabel.h"

@interface JCCartBarButtonItem : JCBarButtonItem

@property (assign, nonatomic) NSInteger cartCount;
@property (strong, nonatomic) JCLabel *lbCount;

@property (assign, nonatomic) BOOL animatedAddCart;//default:YES

- (void)addCartCountBy:(NSInteger)addBy;

@end
