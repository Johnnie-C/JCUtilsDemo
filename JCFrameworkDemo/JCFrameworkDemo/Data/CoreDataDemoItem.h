//
//  CoreDataDemoItem+CoreDataClass.h
//  
//
//  Created by Johnnie Cheng on 28/01/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <MagicalRecord/MagicalRecord.h>

@class CoreDataDemoItemOption;

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataDemoItem : NSManagedObject


+ (NSFetchRequest<CoreDataDemoItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nonatomic) int16_t uid;
@property (nullable, nonatomic, retain) NSOrderedSet<CoreDataDemoItemOption *> *options;

@end

NS_ASSUME_NONNULL_END



