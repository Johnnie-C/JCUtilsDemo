//
//  NSString+JCUtils.h
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JCUtils)

- (BOOL)containsString:(NSString *)substring;
- (BOOL)isValidEmail;

@end
