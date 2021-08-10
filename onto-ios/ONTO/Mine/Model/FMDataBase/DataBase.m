//
//  DataBase.m
//  ONTO
//
//  Created by 赵伟 on 2018/5/3.
/*
 * **************************************************************************************
 *  Copyright © 2014-2018 Ontology Foundation Ltd.
 *  All rights reserved.
 *
 *  This software is supplied only under the terms of a license agreement,
 *  nondisclosure agreement or other written agreement with Ontology Foundation Ltd.
 *  Use, redistribution or other disclosure of any parts of this
 *  software is prohibited except in accordance with the terms of such written
 *  agreement with Ontology Foundation Ltd. This software is confidential
 *  and proprietary information of Ontology Foundation Ltd.
 *
 * **************************************************************************************
 *///

#import "DataBase.h"
#import <FMDB/FMDB.h>
#import "ClaimModel.h"
#import "Config.h"

static DataBase *_DBCtl = nil;


@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}
@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
//    if (_DBCtl == nil) {
//
//        _DBCtl = [[DataBase alloc] init];
//
//        [_DBCtl initDataBase];
//
//    }
//
//    return _DBCtl;
    static DataBase *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[DataBase alloc] init];
        [instance initDataBase];
    });
    return instance;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}
-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];

    
    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",@"tableName",@"id",@"ClaimContext",@"OwnerOntId",@"Content",@"Status"];
     [_db executeUpdate:sqlCreateTable];
 

    [_db close];
    
}

- (void)addClaim:(ClaimModel *)claim  isSoket:(BOOL)isSoket{
    
    
//    if (!isSoket) {
        [_db open];
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"tableName"];
        FMResultSet * rs = [_db executeQuery:sql];
//    DebugLog(@"rs=%@",rs);
        while ([rs next]) {
            
            if ([[rs stringForColumn:@"ClaimContext"] isEqualToString:claim.ClaimContext]&&[[rs stringForColumn:@"OwnerOntId"] isEqualToString:claim.OwnerOntId]) {
                
                NSString *updateSql = [NSString stringWithFormat:@" UPDATE %@ SET %@= '%@' , %@= %@ WHERE %@ = '%@' ",@"tableName",@"Content",claim.Content,@"Status", @"1",@"ClaimContext",claim.ClaimContext];
                
                [_db executeUpdate:updateSql];
                [_db close];
                return;
            }
            
        }
        
//    }
    

     [_db open];
//    NSString *insertSql1= [NSString stringWithFormat:
//                           @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
//                           @"tableName",@"ClaimContext",@"OwnerOntId",@"Content",@"Status", claim.ClaimContext, claim.OwnerOntId, claim.Content,claim.status];
    [_db executeUpdate:[NSString stringWithFormat:
                        @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                        @"tableName",@"ClaimContext",@"OwnerOntId",@"Content",@"Status", claim.ClaimContext, claim.OwnerOntId, claim.Content,claim.status]];
    
    [_db close];
    
}

- (ClaimModel *)getCalimWithClaimContext:(NSString*)ClaimContext andOwnerOntId:(NSString*)OwnerOntId{
    
    [_db open];

//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tableName where ClaimContext = %@",ClaimContext]];
     ClaimModel *calim = [[ClaimModel alloc] init];

    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"tableName"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            
            if ([[rs stringForColumn:@"ClaimContext"] isEqualToString:ClaimContext]&&[[rs stringForColumn:@"OwnerOntId"] isEqualToString:OwnerOntId]) {
                
                NSString * Content = [rs stringForColumn: @"Content"];
                NSString * ClaimContext = [rs stringForColumn:@"ClaimContext"];
                NSString * OwnerOntId = [rs stringForColumn:@"OwnerOntId"];
                NSString * status = [rs stringForColumn:@"status"];

//              DebugLog( @"Content = %@, ClaimContext = %@  OwnerOntId = %@", name, age, address);
                
                calim.ClaimContext = ClaimContext;
                calim.OwnerOntId = OwnerOntId;
                calim.Content = Content;
                calim.status = status;
//            DebugLog( @"Content = %@, ClaimContext = %@ , OwnerOntId = %@", Content, ClaimContext, OwnerOntId);

            }
         
        }
        [_db close];
    }
    return calim;
}

- (void)changtoStatus:(NSString*)status ClaimContext:(NSString*)ClaimContext andOwnerOntId:(NSString*)OwnerOntId{
    
    [_db open];
    
    //    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tableName where ClaimContext = %@",ClaimContext]];
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"tableName"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            
            if ([[rs stringForColumn:@"ClaimContext"] isEqualToString:ClaimContext]&&[[rs stringForColumn:@"OwnerOntId"] isEqualToString:OwnerOntId]) {
                
            NSString *updateSql = [NSString stringWithFormat:@" UPDATE %@ SET  %@= %@ WHERE %@ = %@ ",@"tableName",@"Status", status,@"Status",@"4"];
                
            BOOL issucced = [_db executeUpdate:updateSql];

//                DebugLog(@"%@",issucced);
            }
            
        }
        [_db close];
    }
}


- (NSMutableArray *)getAllClaim{
    
    [_db open];
    
    //    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tableName where ClaimContext = %@",ClaimContext]];
    NSMutableArray *notificationArr = [NSMutableArray array];
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"tableName"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            
            if ([[rs stringForColumn:@"OwnerOntId"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]) {
                
                NSString * Content = [rs stringForColumn: @"Content"];
                NSString * ClaimContext = [rs stringForColumn:@"ClaimContext"];
                NSString * OwnerOntId = [rs stringForColumn:@"OwnerOntId"];
                NSString * status = [rs stringForColumn:@"status"];
                
                //              DebugLog( @"Content = %@, ClaimContext = %@  OwnerOntId = %@", name, age, address);
                ClaimModel *calim = [[ClaimModel alloc] init];

                calim.ClaimContext = ClaimContext;
                calim.OwnerOntId = OwnerOntId;
                calim.Content = Content;
                calim.status = status;
                
//                DebugLog( @"Content = %@, ClaimContext = %@ , OwnerOntId = %@", Content, ClaimContext, OwnerOntId);
                [notificationArr addObject:calim];
                
            }
            
        }
        [_db close];
    }
    
    return notificationArr;
    
}


- (NSMutableArray *)getNotificationArr{
    
    [_db open];
    
    //    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM tableName where ClaimContext = %@",ClaimContext]];
    ClaimModel *calim = [[ClaimModel alloc] init];
    NSMutableArray *notificationArr = [NSMutableArray array];

    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"tableName"];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            
            if ([[rs stringForColumn:@"ClaimContext"] isEqualToString:@"claim:employment_authentication"]&&[[rs stringForColumn:@"OwnerOntId"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:ONT_ID]]) {
                
                NSString * Content = [rs stringForColumn: @"Content"];
                NSString * ClaimContext = [rs stringForColumn:@"ClaimContext"];
                NSString * OwnerOntId = [rs stringForColumn:@"OwnerOntId"];
                NSString * status = [rs stringForColumn:@"status"];

                //              DebugLog( @"Content = %@, ClaimContext = %@  OwnerOntId = %@", name, age, address);
                
                calim.ClaimContext = ClaimContext;
                calim.OwnerOntId = OwnerOntId;
                calim.Content = Content;
                calim.status = status;

//                DebugLog( @"Content = %@, ClaimContext = %@ , OwnerOntId = %@", Content, ClaimContext, OwnerOntId);
                [notificationArr addObject:calim];
                
            }
            
        }
        [_db close];
    }
    
    return notificationArr;
    
}



- (void)deleteCalim:(NSString *)ownerOntId{
    
    [_db open];
    [_db executeUpdate:@"DELETE FROM myClaimTable WHERE own_id = ?",ownerOntId];
    [_db close];
}
- (void)deleteCalim:(NSString *)ownerOntId andClaimContext:(NSString*)ClaimContext{
    [_db open];
    BOOL res =[_db executeUpdate:@"DELETE FROM tableName WHERE OwnerOntId = ? and ClaimContext = ? ",ownerOntId,ClaimContext];
    if (res) {
        DebugLog(@"删除数据成功");
    }else{
        DebugLog(@"删除数据失败");
    }
    [_db close];
}
//@property(nonatomic,copy) NSString *ClaimContext;
//@property(nonatomic,copy) NSString *OwnerOntId;
//@property(nonatomic,copy) NSString *Content;

@end
