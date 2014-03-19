//
//  TemplateViewController.h
//  iCanvas
//
//  Created by YANGRui on 13-11-11.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TemplateViewControllerDelegate <NSObject>
@optional
- (void)passImage:(UIImage *)img;

@end

@interface TemplateViewController : UIViewController
@property (assign, nonatomic) id<TemplateViewControllerDelegate>delegate;
@end
