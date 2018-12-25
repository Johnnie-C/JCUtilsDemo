//
//  NSArray+JCUtils.h
//
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JCUtils)
  
- (NSString *)toJsonStr;
+ (NSArray *)fromJsonStr:(NSString *)json;
  
  @end
