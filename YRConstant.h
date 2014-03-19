//
//  YRConstant.h
//  iCanvas
//
//  Created by 杨锐 on 13-8-17.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#ifndef iCanvas_YRConstant_h
#define iCanvas_YRConstant_h

#define UMAPPKEY @"51cab76356240b834806d636"

/******************************
 定义常用尺寸
 ******************************/

#define GLKColor(r,g,b) GLKVector3Make(r/255.0, g/255.0, b/255.0)

#define BAR_HEIGHT 44
#define APP_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define APP_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height

/******************************
 定义APP沙盒路径
 ******************************/
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TMPPATH NSTemporaryDirectory()
#define CACHPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define DOCUMENTS_PATH(fileName) [DOCUMENTPATH stringByAppendingPathComponent:fileName]//获得Document文件路径

#define CACH_DOCUMENTS_PATH(fileName) [CACHPATH stringByAppendingPathComponent:fileName]//缓存文件路径
#define DOCUMENTS_PATH(fileName) [DOCUMENTPATH stringByAppendingPathComponent:fileName]//Documents文件夹路径

/******************************
 定义RGB颜色
 ******************************/
#define RGBColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a*1.0]

/******************************
 定义常用颜色
 ******************************/
#define CLEAR_COLOR [UIColor clearColor]
#define WHITE_COLOR [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]

/******************************
 定义日志输出模式
 DLog is almost a drop-in replacement for NSLog
 DLog();
 DLog(@"here");
 DLog(@"value: %d", x);
 Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
 ******************************/
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#endif

/******************************
 工具类头文件
 ******************************/
#import "MBProgressHUD.h"
#import "UIColor+HexString.h"
#import "ACEDrawingView.h"
#import "YRNavigator.h"
#import "GLNetworkUtility.h"
#import "UIImage+Loader.h"
#import "YRScrollView.h"
#import "YRFileManager.h"
#import "SBPageFlowView.h"
#import "UIImageView+Async.h"
#import "FTPHelper.h"
#import "AppTool.h"
#import "GRRequestsManager.h"

/******************************
导入视图控制器头文件
******************************/
#import "YRBaseViewController.h"


#endif
