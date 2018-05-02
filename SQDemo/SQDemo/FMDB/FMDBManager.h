//
//  FMDBManager.h
//  SQDemo
//
//  Created by 任鹏 on 2018/4/30.
//  Copyright © 2018年 huyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

typedef void(^FMDBblock)(BOOL isSuccess,id result);
@interface FMDBManager : NSObject
/**block*/
@property (nonatomic, copy)FMDBblock block;
+ (FMDBManager *)shareSingle;
/**创建数据库*/
- (void)initFMDBWithName:(NSString *)name block:(FMDBblock)block;
/**删除数据库*/
- (void)deleteFMDBWithName:(NSString *)name block:(FMDBblock)block;
/**判断表是否存在*/
- (void)checkTableWithName:(NSString *)tableName block:(FMDBblock)block;
/**建表*/
- (void)creatTableWithName:(NSString *)tableName sql:(NSString *)sql block:(FMDBblock)block;
/**删表*/
- (void)deleteTableWithName:(NSString *)tableName block:(FMDBblock)block;
/**更新数据*/
- (void)updateWithSql:(NSString *)sql block:(FMDBblock)block;
/**查询数据*/
- (void)getDataWithSql:(NSString *)sql block:(FMDBblock)block;
/**删除该表所有数据*/
- (void)clearTableWithName:(NSString *)tableName block:(FMDBblock)block;
/**事务*/
- (void)FMDBShiWuWithSqlArr:(NSArray *)sqlArr block:(FMDBblock)block;
/**添加字段/数据迁移*/
- (void)dataMigrationWithTableName:(NSString *)tableName newAdded:(NSString *)newAdded block:(FMDBblock)block;
@end
