//
//  YRScrollView.h
//  LazyScrollVew
//
//  Created by yangrui on 13-6-10.
//  Copyright (c) 2013年 rui yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRZoomingView.h"
@class YRScrollView;
@protocol YRScrollViewDelegate <NSObject>
@optional
- (void)scrollView:(YRScrollView *)scrollView didEndScrollAtIndex:(NSInteger)index;
@end
@interface YRScrollView : UIScrollView<UIScrollViewDelegate>
@property (strong , nonatomic) NSMutableArray *dataArray;
@property (assign) id <YRScrollViewDelegate>delegater;

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray;

-(void)setViewsWithPageNumber:(NSInteger)pageNumber;

@end
