//
//  CoreDataDemoItem+CoreDataClass.m
//  
//
//  Created by Johnnie Cheng on 28/01/18.
//
//

#import "CoreDataDemoItem.h"

@implementation CoreDataDemoItem

@dynamic name;
@dynamic uid;
@dynamic desc;
@dynamic options;

+ (NSFetchRequest<CoreDataDemoItem *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"CoreDataDemoItem"];
}
@end
