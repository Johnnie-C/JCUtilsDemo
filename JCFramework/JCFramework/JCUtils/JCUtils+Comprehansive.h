//
//  JCUtils+Comprehansive.h
//  JCFramework
//
//  Created by Johnnie Cheng on 25/12/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCUtils.h"

@interface JCUtils (Comprehansive)

+ (NSString *)deviceUDID;
+ (void)sendEmailToEmailAddress:(NSString *)email subject:(NSString *)subject;
+ (void)callNumber:(NSString *)number;

@end

