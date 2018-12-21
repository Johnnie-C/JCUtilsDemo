//
//  NSArray+JCUtils.m
//
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//


#import "NSArray+JCUtils.h"

@implementation NSArray (JCUtils)
  
- (NSString *)toJsonStr{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0  error:&error];
  
    if (! jsonData) {
      return @"[]";
    } else {
      return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
  
+ (NSArray *)fromJsonStr:(NSString *)json{
    NSError *error;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
}
  
  @end
