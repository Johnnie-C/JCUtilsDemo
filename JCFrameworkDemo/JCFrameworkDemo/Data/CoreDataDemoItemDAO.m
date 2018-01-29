//
//  CoreDataDemoItemDAO.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 29/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "CoreDataDemoItemDAO.h"

@implementation CoreDataDemoItemDAO

+ (CoreDataDemoItem *)newRecord{
    return [CoreDataDemoItem MR_createEntity];
}

+ (NSArray<CoreDataDemoItem *> *)allRecords{
    return [CoreDataDemoItem MR_findAll];
}

+ (void)saveRecords{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+ (void)deleteRecord:(CoreDataDemoItem *)item{
    [CoreDataDemoItemDAO deleteRecords:@[item]];
}

+ (void)deleteRecords:(NSArray<CoreDataDemoItem *> *)items{
    for(CoreDataDemoItem *item in items){
        [item MR_deleteEntity];
    }
}

+ (void)deleteAllRecords{
    [CoreDataDemoItem MR_truncateAll];
}

@end
