//
//  YRScrollView.m
//  LazyScrollVew
//
//  Created by  yangrui on 13-6-10.
//  Copyright (c) 2013年 rui yang. All rights reserved.
//

#import "YRScrollView.h"

@implementation YRScrollView

{
    NSInteger _numberOfPages;//总共的页数
    NSInteger _currentPage;//当前的页数
    YRZoomingView *_prevImageView;//前面的一页图像
    YRZoomingView *_currImageView;//当前的一页图像
    YRZoomingView *_nextImageView;//后面的一页图像
    CGFloat _width;
    CGFloat _height;
}

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _width = self.frame.size.width;
        _height = self.frame.size.height;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
       self.dataArray = (NSMutableArray *)dataArray;
        _numberOfPages = dataArray.count;
        self.contentSize = CGSizeMake(frame.size.width*_numberOfPages, frame.size.height);
        _prevImageView = [[YRZoomingView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        _currImageView = [[YRZoomingView alloc] initWithFrame:CGRectMake(0, 0,_width, _height)];
        _nextImageView = [[YRZoomingView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
         
    }
    return self;
}

-(void)setViewsWithPageNumber:(NSInteger)pageNumber
{
    _currImageView.frame = CGRectMake(_width*_currentPage, 0, _width, _height);
    _currImageView.imgView.image = nil;//先把图片置空,再加载图片数据
    _currImageView.imgView.image = (UIImage *)[self.dataArray objectAtIndex:_currentPage];
    
    if (pageNumber == 0)//加载第一页的时候
    {
        _prevImageView.frame = CGRectZero;
        _currImageView.frame = CGRectMake(0, 0, _width, _height);
        _nextImageView.frame = CGRectMake(_width, 0, _width, _height);
        if (_numberOfPages != 1)
        {
            _nextImageView.imgView.image = nil;
            _nextImageView.imgView.image = (UIImage *)[self.dataArray objectAtIndex:_currentPage+1];
            
        }
        [self addSubview:_prevImageView];
        [self addSubview:_currImageView];
        [self addSubview:_nextImageView];
    }
    else if (_currentPage == _numberOfPages -1)//倒数第一页的时候
    {
        _nextImageView.frame = CGRectZero;//下一页没有了,所以要向前移动
        _prevImageView.frame = CGRectMake((_currentPage-1)*_width, 0, _width, _height);
        _prevImageView.imgView.image = nil;
        _prevImageView.imgView.image = (UIImage *)[self.dataArray objectAtIndex:_currentPage-1];
    }
    else//一般情况下
    {
       // UIImage *image = _currImageView.imgView.image;
        _prevImageView.frame = CGRectMake((_currentPage-1)*_width, 0, _width, _height);
        _prevImageView.imgView.image = nil;
        _prevImageView.imgView.image = (UIImage *)[self.dataArray objectAtIndex:_currentPage-1];
        //_prevImageView.imgView.image = image;
        _nextImageView.frame = CGRectMake((_currentPage+1)*_width, 0, _width, _height);
        _nextImageView.imgView.image = nil;
        _nextImageView.imgView.image = (UIImage *)[self.dataArray objectAtIndex:_currentPage+1];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    // CGFloat height = scrollView.frame.size.height;
    NSInteger page = floor((scrollView.contentOffset.x - width / 2 ) / width )+ 1;
    
    if ((_currentPage == page)||page < 0||page>_numberOfPages)
    {
        return;
    }
    NSInteger prevPage = _currentPage;
    _currentPage = page;
    self.userInteractionEnabled = NO;//加载数据过程中禁用UIScrollView
    [self performSelectorInBackground:@selector(loadViewsAfterScrolling:) withObject:[NSNumber numberWithInteger:prevPage]];//数据放到后台加载,防止阻塞UI
    if ([self.delegater respondsToSelector:@selector(scrollView:didEndScrollAtIndex:)])
    {
        [self.delegater scrollView:self didEndScrollAtIndex:page];
    }
    
}

- (void)loadViewsAfterScrolling:(NSNumber *)pageNumber
{
    NSInteger prevPage = [pageNumber integerValue];
    YRZoomingView *tempView = nil;
    if(_currentPage - 1 == prevPage)//向右滑动
    {
        tempView = _currImageView;
        _currImageView = _nextImageView;
        _nextImageView = _prevImageView;
        _prevImageView = tempView;
        
        _prevImageView.frame = CGRectMake((_currentPage-1)*_width, 0, _width, _height);
        _currImageView.frame = CGRectMake(_currentPage*_width, 0, _width, _height);
        if (_currentPage == (_numberOfPages - 1))//滑动到最后一页
        {
            _nextImageView.frame = CGRectZero;
        }
        else
        {
            _nextImageView.frame = CGRectMake((_currentPage+1)*_width, 0, _width, _height);
            [self setViewsWithPageNumber:_currentPage];
        }
        _prevImageView.zoomScale = 1.0;
    }
    else if (_currentPage+1 == prevPage)//向左滑动
    {
        tempView = _currImageView;
        _currImageView = _prevImageView;
        _prevImageView = _nextImageView;
        _nextImageView = tempView;
        
        _currImageView.frame = CGRectMake(_currentPage*_width, 0, _width, _height);
        _nextImageView.frame = CGRectMake((_currentPage + 1)*_width, 0, _width, _height);
        
        if (_currentPage == 0)//滑动到第一页
        {
            _prevImageView.frame = CGRectZero;
        }
        else
        {
            _prevImageView.frame = CGRectMake((_currentPage - 1)*_width, 0, _width, _height);
            [self setViewsWithPageNumber:_currentPage];
        }
        _nextImageView.zoomScale = 1.0;
    }
    self.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.userInteractionEnabled = NO;
}



@end
