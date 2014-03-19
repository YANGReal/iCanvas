//
//  DrawingView.h
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"
@interface DrawingView : UIImageView
@property (strong , nonatomic) UIImageView *templateView;
@property (strong , nonatomic) ACEDrawingView *signView;
@property (strong , nonatomic) UIView *renderView;
@property (strong , nonatomic) UIImageView *imgView;

- (void)closeCamera;
- (void)takePicture;
- (void)openCamera;
- (CGRect)getSignRect;
- (void)clear;

- (void)changeOrientation:(UIInterfaceOrientation )orientation;

@end
