//
//  SettingViewController.h
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewControllerDelegate <NSObject>

@optional
- (void)setLineWidth:(CGFloat)witth andColor:(UIColor *)color;

@end

@interface SettingViewController : YRBaseViewController
@property (assign, nonatomic) id<SettingViewControllerDelegate>delegate;
- (void)showInViewController:(UIViewController *)vc;


@end
