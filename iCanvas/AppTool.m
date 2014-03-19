//
//  AppTool.m
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "AppTool.h"

@implementation AppTool

+(void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alert show];
}

+(void)storeObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (id)getObjectForKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}



@end
