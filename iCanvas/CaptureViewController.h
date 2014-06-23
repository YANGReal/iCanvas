//
//  CaptureViewController.h
//  iCanvas
//
//  Created by YANGReal on 14-6-23.
//  Copyright (c) 2014年 yangrui. All rights reserved.
//

#import "YRBaseViewController.h"


@protocol CaptureViewControllerDelegate <NSObject>

@optional

- (void)backFromCaptureViewControllerWithImage:(UIImage *)image;

@end

@interface CaptureViewController : YRBaseViewController
@property (assign , nonatomic) id<CaptureViewControllerDelegate>delegate;
@end
