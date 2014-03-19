//
//  DrawingView.h
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"
#import "PPSSignatureView.h"
@interface DrawingView : UIImageView
@property (strong , nonatomic) UIImageView *templateView;
@property (strong , nonatomic) PPSSignatureView *signView;
@property (strong , nonatomic) UIView *renderView;
@property (strong , nonatomic) UIImageView *imgView;

@property (strong, nonatomic) UIImageView *imgView2;

- (void)closeCamera;
- (void)takePicture;
- (void)openCamera;
- (CGRect)getSignRect;
- (void)clear;

- (void)changeOrientation:(UIInterfaceOrientation )orientation;

@end
