//
//  UIImage+Loader.h
//  ToolFramework
//
//  Created by  Jason on 13-1-29.
//  Copyright (c) 2013年 BlueBox. All rights reserved.
//
// UIImage扩展类

#import <UIKit/UIKit.h>

@interface UIImage (Loader)

/*
 程序内读取文件
 */

+ (UIImage *)imageFromMainBundleFile:(NSString*)aFileName;

/*
 应用程序沙盒内读取文件
 */

+ (UIImage *)imageFromDocumentsFileName:(NSString *)aFileName filePath:(NSString *)path;

/*
 创建纯色UIImage
 */

+ (UIImage *)createImageWithColor:(UIColor *)color;


/*
 从URL获取图片
 */

+ (UIImage *)imageFromURL:(NSString *)url;


/*
 等比缩放
 */

- (UIImage*)scaleToSize:(CGSize)size;
/*
 裁剪图片
 */
- (UIImage*)getSubImage:(CGRect)rect;
@end
