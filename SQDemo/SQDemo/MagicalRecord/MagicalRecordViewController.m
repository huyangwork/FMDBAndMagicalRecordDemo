//
//  MagicalRecordViewController.m
//  SQDemo
//
//  Created by 任鹏 on 2018/4/30.
//  Copyright © 2018年 huyang. All rights reserved.
//

#import "MagicalRecordViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Person+CoreDataProperties.h"
@interface MagicalRecordViewController ()

@end

@implementation MagicalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MagicalRecord";
    
}
- (IBAction)add:(id)sender {
    Person *p = [Person MR_createEntity];
    p.name = @"胡杨";
    p.sex = @"男";
    p.age = 18;
    p.num = @"22222";
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (IBAction)delete:(id)sender {
    Person *p = [Person MR_findFirst];
    [p MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (IBAction)clear:(id)sender {
    NSArray *all = [Person MR_findAll];
    for (Person *p in all) {
        [p MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (IBAction)change:(id)sender {
    NSArray *all = [Person MR_findAll];
    for (Person *p in all) {
        p.age = 8;
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
- (IBAction)get:(id)sender {
    NSArray *all = [Person MR_findAll];
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger i = 0; i < all.count; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        Person *p = all[i];
        [dic setObject:p.name forKey:@"name"];
        [dic setObject:p.sex forKey:@"sex"];
        if (p.num == nil) {
            p.num = @"";
        }
        [dic setObject:p.num forKey:@"num"];
        [dic setObject:[NSString stringWithFormat:@"%lld",p.age] forKey:@"age"];
        [tmp addObject:dic];
    }
    NSLog(@"%@",tmp);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
