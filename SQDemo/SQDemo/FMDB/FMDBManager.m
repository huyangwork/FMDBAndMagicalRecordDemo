//
//  FMDBManager.m
//  SQDemo
//
//  Created by 任鹏 on 2018/4/30.
//  Copyright © 2018年 huyang. All rights reserved.
//

#import "FMDBManager.h"


@interface FMDBManager ()
{
    FMDatabaseQueue *_queue;
}
@end

@implementation FMDBManager
+ (FMDBManager *)shareSingle
{
    static FMDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[FMDBManager alloc] init];
        }
    });
    return manager;
}


- (NSString *)getFMDBPathWithName:(NSString *)name
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",name]];
    return filePath;
}

/**创建数据库*/
- (void)initFMDBWithName:(NSString *)name block:(FMDBblock)block
{
    if (_queue == nil) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self getFMDBPathWithName:name]];
        block(YES,@"创建数据库成功");
    } else {
        block(NO,@"创建数据库失败,已存在数据库");
    }
}
/**删除数据库*/
- (void)deleteFMDBWithName:(NSString *)name block:(FMDBblock)block
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:name]) {
        success = [fileManager removeItemAtPath:name error:nil];
        if (success) {
            block(YES,@"删除数据库成功");
        } else {
            block(NO,@"删除数据库失败");
        }
    }
}
/**判断表是否存在*/
- (void)checkTableWithName:(NSString *)tableName block:(FMDBblock)block
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
            while ([rs next]) {
                NSInteger count = [rs intForColumn:@"count"];
                [db close];
                if (0 == count) {
                    block(NO,nil);
                    NSLog(@"不存在表");
                } else {
                    block(YES,nil);
                    NSLog(@"已存在该表");
                }
            }
        }
    }];
}
/**建表*/
- (void)creatTableWithName:(NSString *)tableName sql:(NSString *)sql block:(FMDBblock)block
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
            while ([rs next]) {
                NSInteger count = [rs intForColumn:@"count"];
                if (0 == count) {
                    NSLog(@"不存在表");
                    BOOL isCreat = [db executeUpdate:sql];
                    [db close];
                    if (isCreat) {
                        block(YES,@"建表成功");
                    } else {
                        block(NO,@"建表失败");
                    }
                } else {
                    NSLog(@"已存在该表");
                }
            }
        }
    }];
}
/**删表*/
- (void)deleteTableWithName:(NSString *)tableName block:(FMDBblock)block
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
           BOOL Success = [db executeUpdate:sqlstr];
            [db close];
            if (Success) {
                block(YES,@"删表成功");
            } else {
                block(NO,@"删表失败");
            }
        }
    }];
}
/**更新数据*/
- (void)updateWithSql:(NSString *)sql block:(FMDBblock)block
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL Success = [db executeUpdate:sql];
            [db close];
            if (Success) {
                block(YES,@"更新数据成功");
            } else {
                block(NO,@"更新数据失败");
            }
        }
    }];
}
/**查询数据库*/
- (void)getDataWithSql:(NSString *)sql block:(FMDBblock)block
{
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet *result = [db executeQuery:sql];
            block(YES,result);
            [db close];
        } else {
            block(NO,@"未获取到数据");
        }
    }];
}
/**删除该表所有数据*/
- (void)clearTableWithName:(NSString *)tableName block:(FMDBblock)block
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            BOOL Success = [db executeUpdate:sqlstr];
            [db close];
            if (Success) {
                block(YES,@"清空成功");
            } else {
                block(YES,@"清空失败");
            }
        }
    }];
}

/**事务*/
- (void)FMDBShiWuWithSqlArr:(NSArray *)sqlArr block:(FMDBblock)block
{
    //TODO:用FMDB的inTransaction方法,事务失败之后数据库会增加一条,如果哪位朋友看见并帮助我改正了这个问题请在简书下面告知,万分感谢!!!!!
    
    
//    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        if ([db open]) {
//            for (NSInteger i = 0; i < sqlArr.count; i ++) {
//               BOOL Success = [db executeUpdate:sqlArr[i]];
//                if (!Success) {
//                    block(NO,@"事务失败");
//                    *rollback = YES;
//                    [db close];
//                    return;
//                }
//            }
//            [db close];
//            block(YES,@"事务成功");
//        }
//    }];
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            [db beginTransaction];
            for (NSInteger i = 0; i < sqlArr.count; i ++) {
               BOOL success = [db executeUpdate:sqlArr[i]];
                if (!success) {
                    [db rollback];
                    [db close];
                    block(NO,@"事务失败");
                    return;
                }
            }
            [db commit];
            [db close];
            block(YES,@"事务提交成功");
        }
    }];
}

@end
