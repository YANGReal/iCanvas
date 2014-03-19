//
//  YRNavigator.h
//  NavAnimation
//
//  Created by 杨锐 on 13-8-16.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRNavigator : NSObject

+(void)pushToViewController:(UIViewController *)nextController  fromViewController:(UIViewController *)currentController;

+(void)popToViewControllerFromViewController:(UIViewController *)currentController;

+(void)popToRootViewControllerFromViewController:(UIViewController *)currentController;

@end
