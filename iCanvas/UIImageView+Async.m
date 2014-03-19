//
//  UIImageView+Async.m
//  iCanvas
//
//  Created by 杨锐 on 13-8-18.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "UIImageView+Async.h"

@implementation UIImageView (Async)

- (void)imageFromFile:(NSString *)filePath
{
    
    DLog(@"path = %@",filePath);
   // [self performSelectorInBackground:@selector(setimagesWith:) withObject:filePath];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
       // DLog(@"image = %@",image);
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image =image;
            });
        }
        else
        {
            NSLog(@"加载图片失败");
        }
    });
}

- (void)setimagesWith:(NSString *)fileName
{
 
    NSData *data = [NSData dataWithContentsOfFile:fileName];
   // DLog(@"self.image = %@",self.image);
    self.image = [UIImage imageWithData:data];
    DLog(@"filePath = %@",fileName);
}


@end

