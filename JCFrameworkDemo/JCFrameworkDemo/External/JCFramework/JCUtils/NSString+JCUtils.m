//
//  NSString+JCUtils.m
//
//  Created by Johnnie on 11/12/17.
//  Copyright © 2017 Putti. All rights reserved.
//

#import "NSString+JCUtils.h"

@implementation NSString (JCUtils)

- (BOOL)containsString:(NSString *)substring{
    BOOL isContain = NO;
    if ([self rangeOfString:substring].location != NSNotFound) {
        isContain = YES;
    }
    
    return isContain;
}

- (BOOL)isValidEmail{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
