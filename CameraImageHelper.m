//
//  CameraImageHelper.m
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "CameraImageHelper.h"
#import <ImageIO/ImageIO.h>

@implementation CameraImageHelper
@synthesize session,image,captureOutput,g_orientation;
@synthesize preview;
@synthesize delegate;

//static CameraImageHelper *sharedInstance = nil;

- (void) initialize
{
    //1.创建会话层
    self.session = [[[AVCaptureSession alloc] init] autorelease];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    

    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    
    
    
#if 1
    int flags = NSKeyValueObservingOptionNew; //监听自动对焦
    [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
#endif

	NSError *error;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [self.session addInput:captureInput];
    
  //  [self.session addInput:backFacingCameraDeviceInput];
    
    //3.创建、配置输出       
    captureOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [captureOutput setOutputSettings:outputSettings];
    
    [outputSettings release];
	[self.session addOutput:captureOutput];
}

- (id) init
{
	if (self = [super init])
        [self initialize];
	return self;
}


//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        NSLog(@"Is adjusting focus? %@", adjustingFocus ? @"YES" : @"NO" );
        NSLog(@"Change dictionary: %@", change);
        if (delegate) {
            [delegate foucusStatus:adjustingFocus];
        }
    }
}


-(void) embedPreviewInView: (UIView *) aView{
    if (!session) return;
    //设置取景
    preview = [AVCaptureVideoPreviewLayer layerWithSession: session];
    preview.frame = _frame;
   // DLog(@"frame1 = %@",NSStringFromCGRect(aView.bounds));
    
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill; 
    [aView.layer addSublayer:preview];
}

- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!preview) {
        return;
    }
    self.preview.frame = _frame;
     [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        g_orientation = UIImageOrientationUp;
        if (isFront)
        {
            g_orientation = UIImageOrientationDown;
        }
        preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        g_orientation = UIImageOrientationDown;
        preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        g_orientation = UIImageOrientationRight;
        preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        g_orientation = UIImageOrientationLeft;
        preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}

-(void)giveImg2Delegate
{
    [delegate didFinishedCapture:image];
}

-(void)Captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }

    //get UIImage
    [captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];   
         image = [[UIImage alloc] initWithCGImage:t_image.CGImage scale:1.0 orientation:g_orientation];

         [self giveImg2Delegate];
     }];
}

- (void) dealloc
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device removeObserver:self forKeyPath:@"adjustingFocus"];

	self.session = nil;
	self.image = nil;
	[super dealloc];
}

#pragma mark Class Interface


- (void) startRunning
{
	[[self session] startRunning];
    [self swapFrontAndBackCameras];
}

- (void) stopRunning
{
	[[self session] stopRunning];
}

-(void)CaptureStillImage
{
    [self  Captureimage];
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}


- (void)swapFrontAndBackCameras
{
    // Assume the session is already running
    NSString *frontOrBack = [AppTool getObjectForKey:@"front"];
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
          //  AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (![frontOrBack isEqualToString:@"YES"])//position == AVCaptureDevicePositionFront
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
                isFront = NO;
            }
            
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
                isFront = YES;
            }
            
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    } 
}


@end
