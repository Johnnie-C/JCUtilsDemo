//
//  CoreDataDemoItemOptionDAO.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 29/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataDemoItemOption.h"

#import <MagicalRecord/MagicalRecord.h>

@interface CoreDataDemoItemOptionDAO : NSObject

+ (CoreDataDemoItemOption *)newRecord;
+ (NSArray<CoreDataDemoItemOption *> *)allRecords;
+ (void)saveRecords;
+ (void)deleteRecord:(CoreDataDemoItemOption *)item;
+ (void)deleteRecords:(NSArray<CoreDataDemoItemOption *> *)items;
+ (void)deleteAllRecords;

@end
