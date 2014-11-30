//
//  DrawingView.m
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "DrawingView.h"
#import "CameraImageHelper.h"

@interface DrawingView ()<PPSSignatureViewDelagete,ACEDrawingViewDelegate>
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
       // NSArray *colorArray = @[@"0,0,0",@"255,255,255",@"128,128,128",@"255,0,0",@"0,255,0",@"0,0,255",@"0,255,255",@"255,255,0",@"255,0,255",@"255,128,0",@"128,0,128",@"153,102,51"];
        
        self.renderView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.renderView];
        self.renderView.backgroundColor = CLEAR_COLOR;
        
        
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
        
        
        NSString *widStr = [AppTool getObjectForKey:@"width"];
        CGFloat penWidth = 0;
        if (widStr.length == 0)
        {
            penWidth = 1;
            
        }
        else
        {
            penWidth = widStr.floatValue;
    
        }
        UIColor *lineColor1 = nil;
        GLKVector3 lineColo2;
        NSString *color = [AppTool getObjectForKey:@"penColor"];
        if (color.length == 0)
        {
            lineColor1 = [UIColor blackColor];
            lineColo2 =  GLKColor(0, 0, 0);
           
        }
        else
        {

            NSArray *arr = [color componentsSeparatedByString:@","];
            int red = [arr[0] intValue];
            int green = [arr[1] intValue];
            int blue = [arr[2] intValue];
            lineColor1 = [UIColor colorWithRed:red green:green blue:blue alpha:1];
            lineColo2 = GLKColor(red, green, blue);
           
        }

        
        NSString *pen = [AppTool getObjectForKey:@"pen"];
        if (![pen isEqualToString:@"NO"])
        {
            self.signView = [[PPSSignatureView alloc] initWithFrame:self.bounds];
            self.signView.delegater = self;
            self.signView.backgroundColor = CLEAR_COLOR;
            self.signView.strokeColor = lineColor1;
            self.signView.fontWidth = penWidth;
            [self addSubview:self.signView];
        }
        else
        {
            self.signView2 = [[ACEDrawingView alloc] initWithFrame:self.bounds];
            self.signView2.delegate = self;
            self.signView2.lineColor = lineColor1;
            self.signView2.backgroundColor = CLEAR_COLOR;
            self.signView2.lineWidth = penWidth;
            [self addSubview:self.signView2];
        }
        
              // self.signView.backgroundColor = [UIColor redColor];
       
        
        self.imgView2 = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView2.backgroundColor = CLEAR_COLOR;
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
        //[self.camera startRunning];
        self.camera.frame = self.bounds;
        [self.camera embedPreviewInView:self.renderView];
         [self.camera startRunning];
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
    [self.camera stopRunning];
    self.camera = nil;
     // DLog(@"orentation = %d",self.imgView.image.imageOrientation);

}

- (void)clear
{
    //self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
    [self.signView erase];
    [self.signView2 clear];
    self.imgView2.image = [UIImage createImageWithColor:CLEAR_COLOR];
    [self.pointArray removeAllObjects];
}

- (void)clearImage
{
    self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
    self.image = [UIImage createImageWithColor:CLEAR_COLOR];
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


- (void)drawingView:(ACEDrawingView *)view drawingBeganWiithPoint:(CGPoint)point
{
    [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)drawingView:(ACEDrawingView *)view drawingMovedWithPoint:(CGPoint)point
{
     [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)drawingView:(ACEDrawingView *)view drawingEndedWithPoint:(CGPoint)point
{
    [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
    self.imgView2.image = self.signView2.image;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.camera.frame = self.bounds;
    self.templateView.frame = self.bounds;
    self.signView.frame = self.bounds;
    self.signView2.frame = self.bounds;
    self.imgView2.frame = self.bounds;
    self.imgView.frame = self.bounds;
}



@end
