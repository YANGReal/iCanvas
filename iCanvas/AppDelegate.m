//
//  AppDelegate.m
//  iCanvas
//
//  Created by 杨锐 on 13-8-7.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.rootViewController = [[YRRootViewController alloc] initWithNibName:@"YRRootViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    [self copyTemplateToDocument];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:DOCUMENTS_PATH(@"Sign")])
    {
        NSError *error = nil;
        [fm createDirectoryAtPath:DOCUMENTS_PATH(@"Sign") withIntermediateDirectories:YES attributes:nil error:&error];
        DLog(@"error = %@",error);
    }

    return YES;
}


-(void)copyTemplateToDocument
{
   if (![YRFileManager fileExistInDirctory:DOCUMENTS_PATH(@"template1.png")])
   {
       NSString *path1 = [[NSBundle mainBundle] pathForResource:@"template1" ofType:@"png"];
       
       [[NSFileManager defaultManager] copyItemAtPath:path1 toPath:DOCUMENTS_PATH(@"template1.png") error:nil];
   }
    
    if (![YRFileManager fileExistInDirctory:DOCUMENTS_PATH(@"template2.png")])
    {
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"template2" ofType:@"png"];
        
        [[NSFileManager defaultManager] copyItemAtPath:path1 toPath:DOCUMENTS_PATH(@"template2.png") error:nil];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
