//
//  CoreDataDemoItemOption.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 28/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "CoreDataDemoItemOption.h"

@implementation CoreDataDemoItemOption

@dynamic name;
@dynamic value;
@dynamic uid;

+ (NSFetchRequest<CoreDataDemoItemOption *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"CoreDataDemoItemOption"];
}


@end
