//
//  JCCoreDataDemoViewController.m
//  JCFrameworkDemo
//
//  Created by Johnnie Cheng on 28/01/18.
//  Copyright © 2018 Johnnie Cheng. All rights reserved.
//

#import "JCCoreDataDemoViewController.h"
#import "CoreDataDemoItemDAO.h"
#import "CoreDataDemoItemOptionDAO.h"
#import "CoreDataDemoItem.h"
#import "CoreDataDemoItemOption.h"
#import "JCCoreDataDemoCell.h"

@interface JCCoreDataDemoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<CoreDataDemoItem *> *items;

@end

@implementation JCCoreDataDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createItems];
    _items = [CoreDataDemoItemDAO allRecords];
    NSLog(@"total itmes count: %ld", _items.count);
    NSLog(@"--------------------------------------------------");
    for(CoreDataDemoItem *item in _items){
        NSLog(@"name: %@, uid: %d, desc: %@", item.name, item.uid, item.desc);
        for(CoreDataDemoItemOption *option in item.options){
            NSLog(@"option name: %@, option value: %@", option.name, option.value);
        }
        
        NSLog(@"--------------------------------------------------");
    }
    
}

- (void)createItems{
    [CoreDataDemoItemDAO deleteAllRecords];
    
    CoreDataDemoItem *item1 = [CoreDataDemoItemDAO newRecord];
    item1.uid = 1;
    item1.name = @"item 1";
    CoreDataDemoItemOption *o1 = [CoreDataDemoItemOptionDAO  newRecord];
    o1.name = @"o1 name";
    o1.value = @"o1 value";
    CoreDataDemoItemOption *o2 = [CoreDataDemoItemOptionDAO  newRecord];
    o2.name = @"o2 name";
    o2.value = @"o2 value";
    item1.options = [NSOrderedSet orderedSetWithArray:@[o1, o2]];
    
    CoreDataDemoItem *item2 = [CoreDataDemoItemDAO newRecord];
    item2.uid = 2;
    item2.name = @"item 2";
    CoreDataDemoItemOption *o3 = [CoreDataDemoItemOptionDAO  newRecord];
    o3.name = @"o3 name";
    o3.value = @"o3 value";
    CoreDataDemoItemOption *o4 = [CoreDataDemoItemOptionDAO  newRecord];
    o4.name = @"o4 name";
    o4.value = @"o4 value";
    item2.options = [NSOrderedSet orderedSetWithArray:@[o3, o4]];
    
    [CoreDataDemoItemDAO saveRecords];
}


#pragma mark - actions
- (IBAction)onAddClicked:(id)sender {
    CoreDataDemoItem *item1 = [CoreDataDemoItemDAO newRecord];
    item1.uid = _items.count + 1;
    item1.name = _txtAdd.text;
    item1.desc = [NSString stringWithFormat:@"this is desc %ld", (long)_items.count + 1];
    CoreDataDemoItemOption *o1 = [CoreDataDemoItemOptionDAO  newRecord];
    o1.name = [NSString stringWithFormat:@"option1 name for item %ld", (long)_items.count + 1];
    o1.value = [NSString stringWithFormat:@"option1 value for item %ld", (long)_items.count + 1];
    CoreDataDemoItemOption *o2 = [CoreDataDemoItemOptionDAO  newRecord];
    o2.name = [NSString stringWithFormat:@"option2 name for item %ld", (long)_items.count + 1];
    o2.value = [NSString stringWithFormat:@"option2 value for item %ld", (long)_items.count + 1];
    item1.options = [NSOrderedSet orderedSetWithArray:@[o1, o2]];
    
    [CoreDataDemoItemDAO saveRecords];
    _items = [CoreDataDemoItemDAO allRecords];
    [_tableView reloadData];
}



@end
