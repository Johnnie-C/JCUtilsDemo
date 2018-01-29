//
//  CoreDataDemoItemOptionDAO.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 29/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "CoreDataDemoItemOptionDAO.h"

@implementation CoreDataDemoItemOptionDAO

+ (CoreDataDemoItemOption *)newRecord{
    return [CoreDataDemoItemOption MR_createEntity];
}

+ (NSArray<CoreDataDemoItemOption *> *)allRecords{
    return [CoreDataDemoItemOption MR_findAll];
}

+ (void)saveRecords{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+ (void)deleteRecord:(CoreDataDemoItemOption *)item{
    [CoreDataDemoItemOptionDAO deleteRecords:@[item]];
}

+ (void)deleteRecords:(NSArray<CoreDataDemoItemOption *> *)items{
    for(CoreDataDemoItemOption *item in items){
        [item MR_deleteEntity];
    }
}

+ (void)deleteAllRecords{
    [CoreDataDemoItemOption MR_truncateAll];
}

@end
