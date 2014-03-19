//
//  AppTool.h
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SERVER @"server"
#define PORT @"port"
#define kUID @"uid"
#define PASSWORD @"password"
@interface AppTool : NSObject

+(void)showAlert:(NSString *)title message:(NSString *)message;

+(void)storeObject:(id)obj forKey:(NSString *)key;
+(id)getObjectForKey:(id)key;
@end
