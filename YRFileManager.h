//
//  YRFileManager.h
//  iCanvas
//
//  Created by 杨锐 on 13-8-17.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthsizeSingleton.h"
@interface YRFileManager : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(YRFileManager)

- (NSArray *)getAllFilesInDirectory:(NSString *)path;

- (NSArray *)getAllFilesInDocumentsDirectory;

- (BOOL)deleteFileInDirectory:(NSString *)path;

- (BOOL)deleteFileInDocumentsDirctoryWithFileName:(NSString *)fileName;

- (BOOL)saveFile:(NSData *)file withFileName:(NSString *)fileName;

+ (BOOL)fileExistInDirctory:(NSString *)path;

@end
