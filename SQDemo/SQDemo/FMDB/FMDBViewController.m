//
//  FMDBViewController.m
//  SQDemo
//
//  Created by 任鹏 on 2018/4/30.
//  Copyright © 2018年 huyang. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDBManager.h"
#import <FMDB.h>
@interface FMDBViewController ()

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDBDemo";
}
- (IBAction)creatTable:(id)sender {
    NSString *sql = @"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'name' VARCHAR(255),'sex' VARCHAR(255),'age' VARCHAR(255)) ";
    [[FMDBManager shareSingle] creatTableWithName:@"person" sql:sql block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)deleTable:(id)sender {
    [[FMDBManager shareSingle] deleteTableWithName:@"person" block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)checkTable:(id)sender {
    [[FMDBManager shareSingle] checkTableWithName:@"person" block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)cleanTable:(id)sender {
    [[FMDBManager shareSingle] clearTableWithName:@"person" block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)add:(id)sender {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO person ('name', 'age', 'sex') VALUES ('%@','%@','%@');", @"胡杨", @"20",@"男"];
    [[FMDBManager shareSingle] updateWithSql:sql block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)delete:(id)sender {
    NSString *sql = @"DELETE FROM person WHERE id = 8;";
    [[FMDBManager shareSingle] updateWithSql:sql block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];

}
- (IBAction)change:(id)sender {
    NSString *sql = @"UPDATE person SET age = '18' WHERE id = 7;";
    [[FMDBManager shareSingle] updateWithSql:sql block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)get:(id)sender {
    NSString *sql = @"SELECT * FROM person";
    [[FMDBManager shareSingle] getDataWithSql:sql block:^(BOOL isSuccess, id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tmp = [NSMutableArray array];
        while ([rs next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *ID = [rs stringForColumn:@"id"];
            [dic setObject:ID forKey:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            [dic setObject:name forKey:@"name"];
            NSString *age = [rs stringForColumn:@"age"];
            [dic setObject:age forKey:@"age"];
            NSString *sex = [rs stringForColumn:@"sex"];
            [dic setObject:sex forKey:@"sex"];
//            NSString *num = [rs stringForColumn:@"num"];
//            if (num == nil) {
//                num = @"";
//            }
//            [dic setObject:num forKey:@"num"];
            [tmp addObject:dic];
        }
        NSLog(@"%@",tmp);
    }];
}
- (IBAction)siwuClick:(id)sender {
    NSArray *sqlArray = @[[NSString stringWithFormat:@"INSERT INTO person ('name', 'age', 'sex') VALUES ('%@','%@','%@');", @"胡杨", @"20",@"男"],[NSString stringWithFormat:@"INSERT INTO person ('name', 'age', 'sex') VALUES ('%@','%@','%@');", @"胡杨", @"20",@"男"],[NSString stringWithFormat:@"INSERT INTO person ('name', 'age', 'sex') VALUES ('%@','%@','%@');", @"胡杨", @"20",@"男"],[NSString stringWithFormat:@"INSERT INTO person ('name', 'age', 'sex') VALUES ('%@','%@','%@');", @"胡杨", @"20",@"男"]];
    [[FMDBManager shareSingle] FMDBShiWuWithSqlArr:sqlArray block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)dataM:(id)sender {
    /**数据迁移*/
    [[FMDBManager shareSingle] dataMigrationWithTableName:@"person" newAdded:@"num" block:^(BOOL isSuccess, id result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
