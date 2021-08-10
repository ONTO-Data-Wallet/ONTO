//
//  FileManager.h
//  pnlPianoClassing_teacher
//
//  Created by Wen xu on 2018/5/10.
//  Copyright © 2018年 agl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ONTODAppHistoryListModel;

@interface FileManager : NSObject

//初始化
+ (instancetype)sharedInstance;

//根据标签名称创建文件
-(void)creatFileWithTags:(NSArray*)tags;

//写文件
-(void)writeFileOfModel:(ONTODAppHistoryListModel*)model WithKey:(NSString*)key;

//读取文件
-(NSMutableArray*)readFileWithKey:(NSString*)key;

//删除文件
-(void)removeFileOfModel:(ONTODAppHistoryListModel*)model WithKey:(NSString*)key;

//清空文件列表
-(void)removeFileOfListWithKey:(NSString*)key;

//获取文件的标签类型
-(NSDictionary*)acquireTagsData;

//获取文件的标签类型--传入classId
-(NSDictionary*)acquireTagsDataWithClassId:(NSString*)classId;

//清除所有文件--按课删除 or classId传nil 全部删除
-(void)removeAllFileListsWithClassId:(NSString*)classId;

//取出对应classID的标签
-(NSArray*)getTagsWithClassId:(NSString*)classId InArray:(NSArray*)tags;

@end
