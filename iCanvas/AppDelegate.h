//
//  AppDelegate.h
//  iCanvas
//
//  Created by 杨锐 on 13-8-7.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRRootViewController.h"
//@class YRRootViewController;
#import "YRNaviController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YRRootViewController *rootViewController;
@property (strong ,nonatomic) UINavigationController *navigationController;

@end
