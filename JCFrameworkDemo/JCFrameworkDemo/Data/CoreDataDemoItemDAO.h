//
//  CoreDataDemoItemDAO.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 29/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataDemoItem.h"

#import <MagicalRecord/MagicalRecord.h>

@interface CoreDataDemoItemDAO : NSObject

+ (CoreDataDemoItem *)newRecord;
+ (NSArray<CoreDataDemoItem *> *)allRecords;
+ (void)saveRecords;
+ (void)deleteRecord:(CoreDataDemoItem *)item;
+ (void)deleteRecords:(NSArray<CoreDataDemoItem *> *)items;
+ (void)deleteAllRecords;

@end
