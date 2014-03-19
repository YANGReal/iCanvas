//
//  YRNavigator.m
//  NavAnimation
//
//  Created by 杨锐 on 13-8-16.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "YRNavigator.h"

@implementation YRNavigator

+(void)pushToViewController:(UIViewController *)nextController fromViewController:(UIViewController *)currentController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *nextView = nextController.view;
    UIView *currentView = currentController.view;
    currentView.alpha = 1.0;
    CGFloat width = currentView.frame.size.width;
    CGFloat height = currentView.frame.size.height;
    nextView.frame = CGRectMake(width, 20, width,height);
    [window addSubview:nextView];
    
    [UIView animateWithDuration:0.5 animations:^{
        nextView.frame = CGRectMake(0, 20, width, height);
        currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
        currentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [nextView removeFromSuperview];
        currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        [currentController.navigationController pushViewController:nextController animated:NO];
    }];
}

+(void)popToViewControllerFromViewController:(UIViewController *)currentController
{
    CGFloat width = currentController.view.frame.size.width;
    CGFloat height = currentController.view.frame.size.height;
    
    NSInteger index = [currentController.navigationController.viewControllers indexOfObject:currentController];
  //  NSLog(@"index = %d",index);
    UIViewController *vc = currentController.navigationController.viewControllers[index-1];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = vc.view;
    
    view.frame = CGRectMake(0, 20, width, height);
    view.alpha = 0;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [window insertSubview:view atIndex:0];
    [UIView animateWithDuration:0.5 animations:^
     {
         currentController.view.frame = CGRectMake(width, 0, width, height);
         view.alpha = 1;
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
     }
                     completion:^(BOOL finished)
     {
         [view removeFromSuperview];
         [currentController.navigationController popViewControllerAnimated:NO];
     }];
}

+(void)popToRootViewControllerFromViewController:(UIViewController *)currentController
{
    CGFloat width = currentController.view.frame.size.width;
    CGFloat height = currentController.view.frame.size.height;

    UIViewController *rootVC = currentController.navigationController.viewControllers[0];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = rootVC.view;
    
    view.frame = CGRectMake(0, 20, width, height);
    view.alpha = 0;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
    [window insertSubview:view atIndex:0];
    [UIView animateWithDuration:0.5 animations:^
     {
         currentController.view.frame = CGRectMake(width, 0, width, height);
         view.alpha = 1;
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
     }
                     completion:^(BOOL finished)
     {
         [view removeFromSuperview];
         [currentController.navigationController popToRootViewControllerAnimated:NO];
     }];

    
}

@end
