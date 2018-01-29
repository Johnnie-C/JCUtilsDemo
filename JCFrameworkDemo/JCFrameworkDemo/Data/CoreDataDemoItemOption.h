//
//  CoreDataDemoItemOption.h
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 28/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataDemoItemOption : NSManagedObject

+ (NSFetchRequest<CoreDataDemoItemOption *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *value;
@property (nonatomic) int16_t uid;

@end

NS_ASSUME_NONNULL_END
