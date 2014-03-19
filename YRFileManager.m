//
//  YRFileManager.m
//  iCanvas
//
//  Created by 杨锐 on 13-8-17.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "YRFileManager.h"

@implementation YRFileManager
SYNTHESIZE_SINGLETON_FOR_CLASS(YRFileManager)
- (NSArray *)getAllFilesInDirectory:(NSString *)path;
{
    NSMutableArray *fileList = [NSMutableArray array];
    NSError *error;
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (error)
    {
        return nil;
    }
    //DLog(@"tmplist = %@",tmplist);
    
    for (NSString *fileName in tmplist)
    {
        if ([fileName hasSuffix:@".png"]||[fileName hasSuffix:@".jpg"])
        {
            NSString *fullPath = DOCUMENTS_PATH(fileName);
            fullPath = [fullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // if ([self fileExistInDirctory:fullPath])
            {
                [fileList addObject:fullPath];
            }

        }
    }
    return fileList;
}

- (BOOL)saveFile:(NSData *)file withFileName:(NSString *)fileName
{
    NSString *fullPath = CACH_DOCUMENTS_PATH(fileName);
    BOOL succeed =  [file writeToFile:fullPath atomically:YES];
    return succeed;
}

- (NSArray *)getAllFilesInDocumentsDirectory
{
   return  [self getAllFilesInDirectory:DOCUMENTPATH];
}

+ (BOOL)fileExistInDirctory:(NSString *)path
{
   return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)deleteFileInDirectory:(NSString *)path
{
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL deleted = [fm removeItemAtPath:path error:&error];
    DLog(@"error = %@",error.userInfo);
    return deleted;
}

- (BOOL)deleteFileInDocumentsDirctoryWithFileName:(NSString *)fileName
{
    return [self deleteFileInDirectory:DOCUMENTS_PATH(fileName)];
}

@end
