//
//  FileManager.m
//  pnlPianoClassing_teacher
//
//  Created by Wen xu on 2018/5/10.
//  Copyright © 2018年 agl. All rights reserved.
//

#import "FileManager.h"
#import "ONTODAppHistoryListModel.h"

#define FILETYPE         @"plist"          //文件类型
#define HISTORYLIST      @"HistoryList"    //历史列表
#define COLLECTIONLIST   @"CollectionList" //收藏列表
#define DATALIST         @"DataList"       //默认列表
#define TAGLIST          @"TagList"        //标签列表

typedef NS_ENUM(NSInteger,SoundListType) {
    TypeOfCollection,     //收藏列表
    TypeOfHistory,        //收听历史
    TypeOfDefault,        //默认列表
    TypeOTagList          //标签列表
};

@interface FileManager ()
{
    NSMutableSet        *_tagCheckMSet;
    NSArray             *_codeTags;
    NSString            *_classId;
}
@property(nonatomic,strong)NSMutableArray       *tagsMarr;
@property(nonatomic,strong)NSMutableSet         *mCodeMSet;
@end

static FileManager *_instance = nil;

@implementation FileManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

//写文件
-(void)writeFileOfModel:(ONTODAppHistoryListModel*)model WithKey:(NSString*)key
{
    if ([self p_existFileWithName:[self p_DocumentPathOfFileName:key] withModel:model withKey:key])
    {
        NSLog(@"文件写入成功");
//        [self p_addObject:[self p_dictoryWithModel:model]];
    }
}

-(BOOL)p_wirteIntoFileWithModel:(ONTODAppHistoryListModel*)model
{
    //先取工程中的文件，然后用将要写入的数据构建新的数组
    NSString *path = [self p_BundlePathOfFileName:HISTORYLIST];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    [array addObject:model];
    //获取沙盒的路径，将文件在沙盒中写入
    NSString *plistLocation = [self p_DocumentPathOfFileName:HISTORYLIST];
    if ([array writeToFile:plistLocation atomically:YES])
    {
        NSLog(@"写入成功");
        NSArray *arr = [NSArray arrayWithContentsOfFile:plistLocation];
        NSLog(@"%@", arr);
        
        return YES;
    }
    
    return NO;
}

//获取工程文件路径
-(NSString*)p_BundlePathOfFileName:(NSString*)fileName
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:FILETYPE];
}

//获取沙盒文件路径
-(NSString*)p_DocumentPathOfFileName:(NSString*)fileName
{
    NSString *fileNameWithType = [NSString stringWithFormat:@"%@.plist", fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileNameWithType];
}

//读取文件
-(NSMutableArray*)readFileWithKey:(NSString*)key
{
    return [NSMutableArray arrayWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
}

//删除文件中某个元素
-(void)removeFileOfModel:(ONTODAppHistoryListModel*)model WithKey:(NSString*)key
{
    if ([self p_removeExistFileWithName:[self p_DocumentPathOfFileName:key] withModel:model withKey:key])
    {
        NSLog(@"删除成功");
    }
}

//清空文件列表
-(void)removeFileOfListWithKey:(NSString*)key
{
    if ([self p_removeListInFile:[self p_DocumentPathOfFileName:key] WtihType:key])
    {
        NSLog(@"删除成功");
    }
}

//获取文件的标签类型
-(NSDictionary*)acquireTagsData
{
    NSArray *tagList = [[NSUserDefaults standardUserDefaults] objectForKey:TAGLIST];
    NSLog(@"%@",tagList);
    NSMutableDictionary *tagsDataDict = [NSMutableDictionary dictionary];
    [tagList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取obj的对应的文件
        NSArray *tags = [self readFileWithKey:obj];
        [tagsDataDict setObject:tags forKey:obj];
    }];
    
    return tagsDataDict;
}

//获取文件的标签类型--传入classId
-(NSDictionary*)acquireTagsDataWithClassId:(NSString*)classId
{
    NSString *tmpClassId = classId;
    NSArray *tagList = [[NSUserDefaults standardUserDefaults] objectForKey:TAGLIST];
    //ID排序
    NSMutableArray *mTagList = [NSMutableArray arrayWithArray:tagList];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES];
    [mTagList sortUsingDescriptors:@[sort]];
    tagList = mTagList;
    NSLog(@"%@",tagList);
    NSMutableDictionary *tagsDataDict = [NSMutableDictionary dictionary];
    [tagList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //获取obj的对应的文件
        NSArray *tags = [self readFileWithKey:obj];
        for (NSDictionary *dict in tags)
        {
            NSString *tag_classId = dict[@"classId"];
            if ([tag_classId isEqualToString:tmpClassId])
            {
                [tagsDataDict setObject:tags forKey:obj];
            }
        }
    }];
    
    return tagsDataDict;
}

//根据标签名称创建文件
-(void)creatFileWithTags:(NSArray*)tags
{
    [tags enumerateObjectsUsingBlock:^(ONTODAppHistoryListModel *model, NSUInteger idx, BOOL * _Nonnull stop){
        //根据对应的key创建文件
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:[self p_DocumentPathOfFileName:model.historyTitle] contents:nil attributes:nil];
        if (result)
        {
            NSLog(@"文件创建成功");
        }
    }];
}

#pragma mark - Private Method
-(void)p_addObject:(NSDictionary*)object
{
    [self.mCodeMSet addObject:object[@"tag_code"]];
    _codeTags = [self.mCodeMSet allObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_codeTags forKey:TAGLIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//清空播放列表
-(BOOL)p_removeListInFile:(NSString*)fileName WtihType:(NSString*)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName] == NO)
    {
        NSLog(@"不存在");
        return NO;
    }
    else
    {
        NSLog(@"存在");
        NSMutableArray *plistArr = [[NSMutableArray alloc] initWithContentsOfFile:[self p_DocumentPathOfFileName:type]];
        
        if (_classId)
        {
            plistArr = [self p_removeObjectWithClassId:_classId InArray:plistArr];
        }
        else
        {
            [plistArr removeAllObjects];
        }
        
        if ([plistArr writeToFile:[self p_DocumentPathOfFileName:type] atomically:YES])
        {
            NSLog(@"写入成功");
            NSArray *arr = [NSArray arrayWithContentsOfFile:[self p_DocumentPathOfFileName:type]];
            NSLog(@"%@", arr);
            
            return YES;
        }
        
    }
    
    return NO;
}

//清除文件中对应课程Id的数据
-(NSMutableArray*)p_removeObjectWithClassId:(NSString*)classId InArray:(NSMutableArray*)tagList
{
    if (tagList && tagList.count>0)
    {
        NSArray *tagArr = [NSArray arrayWithArray:tagList];
        [tagArr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *classId_Tag = dict[@"classId"];
            if ([classId isEqualToString:classId_Tag])
            {
                [tagList removeObject:dict];
            }
        }];
    }
    
    return tagList;
}

//判断沙盒是否存在该文件，并删除某个元素
-(void)p_existFileAndRemove:(NSString*)fileName withDict:(NSDictionary*)dict withType:(NSString*)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName] == YES)
    {
        
    }
}

//判断沙盒是否已经存在该文件
-(BOOL)p_existFileWithName:(NSString*)fileName withModel:(ONTODAppHistoryListModel*)model withKey:(NSString*)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName] == NO)
    {
        NSLog(@"不存在");
        NSMutableArray *plistArr = [[NSMutableArray alloc] init];
        [plistArr addObject:[self p_dictoryWithModel:model]];
        if ([plistArr writeToFile:fileName atomically:YES])
        {
            NSLog(@"写入成功");
            NSArray *arr = [NSArray arrayWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
            NSLog(@"%@", arr);
            
            return YES;
        }
        
    }
    else
    {
        NSLog(@"存在");
        NSMutableArray *plistArr = [[NSMutableArray alloc] initWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
        [plistArr addObject:[self p_dictoryWithModel:model]];
        
        if ([plistArr writeToFile:[self p_DocumentPathOfFileName:key] atomically:YES])
        {
            NSLog(@"写入成功");
            NSArray *arr = [NSArray arrayWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
            NSLog(@"%@", arr);
            
            return YES;
        }
        
    }
    
    return NO;
}

//删除沙盒某个文件
-(BOOL)p_removeExistFileWithName:(NSString*)fileName withModel:(ONTODAppHistoryListModel*)model withKey:(NSString*)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileName] == NO)
    {
        NSLog(@"不存在");
        return NO;
    }
    else
    {
        NSLog(@"存在");
        NSMutableArray *plistArr = [[NSMutableArray alloc] initWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
        
        NSDictionary *dict = [self p_dictoryWithModel:model];
        
        //超过5秒不允许删除
        if ([self p_compare:dict[@"add_time"]] > 5)
        {
            return NO;
        }
        
        [plistArr removeObject:[self p_dictoryWithModel:model]];
        
        if ([plistArr writeToFile:[self p_DocumentPathOfFileName:key] atomically:YES])
        {
            NSLog(@"写入成功");
            NSArray *arr = [NSArray arrayWithContentsOfFile:[self p_DocumentPathOfFileName:key]];
            NSLog(@"%@", arr);
            
            return YES;
        }
        
    }
    
    return NO;
}

//数据去重复并排序---针对收藏列表
-(NSMutableArray*)p_romeveDuplicate:(NSMutableArray*)dataList
{
    NSMutableArray *marr = [NSMutableArray array];
    NSSet *set = [NSSet setWithArray:dataList];
    if (set.count > 0)
    {
        for (NSDictionary *dict in set)
        {
            [marr addObject:dict];
        }
    }
    
    return marr;
}

//model转Dictionary
-(NSDictionary*)p_dictoryWithModel:(ONTODAppHistoryListModel*)model
{
    return @{@"historyTitle":model.historyTitle,@"historyUrlStr":model.historyUrlStr};
}

//比较两个日期大小
-(NSInteger)p_compare:(NSString *)startTime
{
    NSDate *nowDate = [NSDate date]; // 当前时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:nowDate];
    NSDate *localDate = [nowDate  dateByAddingTimeInterval:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *startDate = [formatter dateFromString:startTime]; // 传入的时间
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:startDate toDate:localDate options:0];
    NSLog(@"second=%zd",compas.second);
    
    return compas.second;
}

//获取当前时间
-(NSString*)p_getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//清除所有文件--按课删除
-(void)removeAllFileListsWithClassId:(NSString*)classId
{
    _classId = classId;
    NSArray *tagList = [[NSUserDefaults standardUserDefaults] objectForKey:TAGLIST];
    NSLog(@"%@",tagList);
    [tagList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //删除obj的对应的文件
        [self removeFileOfListWithKey:obj];
    }];
}

//取出对应classID的标签
-(NSArray*)getTagsWithClassId:(NSString*)classId InArray:(NSArray*)tags
{
    NSMutableArray *MTags = [NSMutableArray array];
    if (tags.count > 0)
    {
        [tags enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *classId_Tag = dict[@"classId"];
            if ([classId isEqualToString:classId_Tag])
            {
                [MTags addObject:dict];
            }
        }];
    }
    return MTags;
}

#pragma mark - Properties
-(NSMutableArray*)tagsMarr
{
    if (!_tagsMarr)
    {
        _tagsMarr = [NSMutableArray array];
    }
    return _tagsMarr;
}

-(NSMutableSet*)mCodeMSet
{
    if (!_mCodeMSet)
    {
        _mCodeMSet = [[NSMutableSet alloc] init];
    }
    return _mCodeMSet;
}

@end

