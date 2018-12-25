//
//  NSDictionary+JCUtils.m
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import "NSDictionary+JCUtils.h"

@implementation NSDictionary (JCUtils)

- (NSString *)stringForKey:(NSString *)key{
    return [self objectForKeyIsNotNull:key] ? [self objectForKey:key] : nil;
}

- (BOOL)boolForKey:(NSString *)key{
    return [self objectForKeyIsNotNull:key] ? [[self objectForKey:key] boolValue] : NO;
}

- (NSInteger)integerForKey:(NSString *)key{
    return [self objectForKeyIsNotNull:key] ? [[self objectForKey:key] integerValue] : 0;
}

- (float)floatForKey:(NSString *)key{
    return [self objectForKeyIsNotNull:key] ? [[self objectForKey:key] floatValue] : 0.0;
}

- (NSArray *)arrayForKey:(NSString *)key{
    return [self objectForKeyIsNotNull:key] ? [self objectForKey:key] : nil;
}

- (NSURL *)urlForKey:(NSString *)key{
    return [self stringForKey:key] ? [NSURL URLWithString:[self stringForKey:key]] : nil;
}

- (BOOL)objectForKeyIsNotNull:(NSString *)key{
    return [self objectForKey:key] && ![[self objectForKey:key] isEqual:[NSNull null]];
}

- (NSString*) toJSONStr{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingOptions)0  error:&error];
    
    if (! jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSDictionary *)fromJsonStr:(NSString *)json{
    NSError *error;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
}
    
@end
