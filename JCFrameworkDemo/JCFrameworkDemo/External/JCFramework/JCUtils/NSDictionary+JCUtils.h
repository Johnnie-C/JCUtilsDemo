//
//  NSDictionary+JCUtils.h
//  
//
//  Created by Johnnie on 4/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JCUtils)

- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSURL *)urlForKey:(NSString *)key;

- (NSString*) toJSONStr;

@end
