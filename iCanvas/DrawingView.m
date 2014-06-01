//
//  DrawingView.m
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "DrawingView.h"
#import "CameraImageHelper.h"

@interface DrawingView ()<PPSSignatureViewDelageter>
@property (strong , nonatomic) NSMutableArray *pointArray;
@property (strong , nonatomic) CameraImageHelper *camera;
@end

@implementation DrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.pointArray = [NSMutableArray array];
        self.contentMode = UIViewContentModeScaleAspectFit;
       // self.image = [UIImage createImageWithColor:CLEAR_COLOR];
        NSArray *colorArray = @[@"0,0,0",@"255,255,255",@"128,128,128",@"255,0,0",@"0,255,0",@"0,0,255",@"0,255,255",@"255,255,0",@"255,0,255",@"255,128,0",@"128,0,128",@"153,102,51"];
        
        self.renderView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.renderView];
        
        
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.backgroundColor = CLEAR_COLOR;
        self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
        [self addSubview:self.imgView];
        
        self.userInteractionEnabled = YES;
        self.templateView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.templateView.contentMode = UIViewContentModeScaleToFill;
        self.templateView.backgroundColor = CLEAR_COLOR;
        
        NSString *template = [AppTool getObjectForKey:@"template"];
        if (template.length == 0)
        {
            self.templateView.image = [UIImage imageFromMainBundleFile:@"template1.png"];
        }
        else
        {
            self.templateView.image = [UIImage imageWithContentsOfFile:template];
        }
        
        [self addSubview:self.templateView];
        
        self.signView = [[PPSSignatureView alloc] initWithFrame:self.bounds];
        self.signView.delegater = self;
        self.signView.backgroundColor = CLEAR_COLOR;
        NSString *widStr = [AppTool getObjectForKey:@"width"];
        if (widStr.length == 0)
        {
             self.signView.fontWidth = 1;
        }
        else
        {
            self.signView.fontWidth = widStr.floatValue;
        }
        
        NSString *colorIndex = [AppTool getObjectForKey:@"color"];
        if (colorIndex.length == 0)
        {
            self.signView.color = GLKColor(0, 0, 0);
        }
        else
        {
            NSInteger index = colorIndex.integerValue;
            NSString *colorStr = colorArray[index];
            NSArray *arr = [colorStr componentsSeparatedByString:@","];
            int red = [arr[0] intValue];
            int green = [arr[1] intValue];
            int blue = [arr[2] intValue];
            self.signView.color = GLKColor(red, green, blue);
        }
        [self addSubview:self.signView];
        
        self.imgView2 = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView2.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgView2];
        
    }
    return self;
}

- (CGRect)getSignRect
{
    if (self.pointArray.count < 2)
    {
        return self.bounds;
    }
    NSMutableArray *arrayX = [NSMutableArray array];
    NSMutableArray *arrayY = [NSMutableArray array];
    for (NSValue *value in self.pointArray)
    {
        CGPoint point = [value CGPointValue];
        NSNumber *x = [NSNumber numberWithInteger:point.x];
        NSNumber *y = [NSNumber numberWithInteger:point.y];
        [arrayX addObject:x];
        [arrayY addObject:y];
    }
    
    [arrayX sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2];
    }];
    [arrayY sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2];
    }];
    NSNumber *numX1 = arrayX[0];
    NSNumber *numX2 = [arrayX lastObject];
    NSNumber *numY1 = arrayY[0];
    NSNumber *numY2 = [arrayY lastObject];
    NSString *signWidth = [AppTool getObjectForKey:@"width"];
    if (signWidth.length == 0)
    {
        signWidth = @"5";
    }
    CGFloat sw= signWidth.floatValue;
  
    if (signWidth.length == 0)
    {
        sw = 5.0;
    }
    
    CGFloat width = numX2.floatValue - numX1.floatValue;
    CGFloat height = numY2.floatValue - numY1.floatValue;
    CGFloat x = numX1.floatValue;
    CGFloat y = numY1.floatValue;
    if ([[UIScreen mainScreen] scale]>1)
    {
       
        return CGRectMake((x-sw)*2, (y-sw)*2, (width+sw+10)*2, (height+sw+10)*2);
    }
    //DLog(@"rect = %@",NSStringFromCGRect(CGRectMake(x-sw, y-sw, width+sw+10, height+sw+10)));
    return CGRectMake(x-sw, y-sw, width+sw+10, height+sw+10);
    return CGRectZero;
}



- (void)openCamera
{
    self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
    if (self.camera == nil)
    {
        self.camera = [[CameraImageHelper alloc] init];
        [self.camera startRunning];
        [self.camera embedPreviewInView:self.renderView];
        [self.camera changePreviewOrientation:[[UIApplication sharedApplication]statusBarOrientation]];
    }
}

- (void)closeCamera
{
    self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
    [self.camera stopRunning];
    self.camera = nil;
}

- (void)takePicture
{
    [self.camera CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
}

- (void)getImage
{
    self.imgView.image = [self.camera image];

}

- (void)clear
{
    self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
    [self.signView erase];
    self.imgView2.image = [UIImage createImageWithColor:CLEAR_COLOR];
    [self.pointArray removeAllObjects];
}


- (void)changeOrientation:(UIInterfaceOrientation )orientation
{
    [self.camera changePreviewOrientation:orientation];
}

- (void)signView:(PPSSignatureView *)view signBeganWiithPoint:(CGPoint)point
{
   
    [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
    
}

- (void)signView:(PPSSignatureView *)view signMovedWithPoint:(CGPoint)point
{
     [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)signView:(PPSSignatureView *)view signEndedWithPoint:(CGPoint)point
{
    [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
    self.imgView2.image = self.signView.signatureImage;
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.templateView.frame = self.bounds;
    self.signView.frame = self.bounds;
    self.imgView2.frame = self.bounds;
}



@end
