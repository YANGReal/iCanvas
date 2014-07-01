//
//  CaptureViewController.m
//  iCanvas
//
//  Created by YANGReal on 14-6-23.
//  Copyright (c) 2014年 yangrui. All rights reserved.
//

#import "CaptureViewController.h"
#import "CameraImageHelper.h"
@interface CaptureViewController ()
{
    BOOL didTake;
}
@property (weak , nonatomic) IBOutlet UIImageView *imgView;
@property (strong , nonatomic) CameraImageHelper *camera;
@property (weak , nonatomic) IBOutlet UIButton *takeBtn;
@property (weak , nonatomic) IBOutlet UIButton *backBtn;
@property (weak , nonatomic) IBOutlet UIImageView *countView;


- (IBAction)takePicture:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation CaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // if(self.uii)
   
    [self openCamera];
    self.countView.center = self.view.center;
    NSArray *arr = @[[UIImage imageNamed:@"003.png"],
                     [UIImage imageNamed:@"002.png"],
                     [UIImage imageNamed:@"001.png"]];
    self.countView.animationDuration = 3.0;
    self.countView.animationImages = arr;
  
}

- (void)openCamera
{
    CGRect rect = CGRectMake(0, 0, 768, 1024);
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        rect = CGRectMake(0, 0, 1024, 768);
    }
 //   [_imgView.layer removeFromSuperlayer];
   //  [_takeBtn.layer removeFromSuperlayer];
    if (self.camera == nil)
    {
        self.camera = [[CameraImageHelper alloc] init];
        [self.camera startRunning];
        self.camera.frame = rect;
        [self.camera embedPreviewInView:self.view];
        [self.camera changePreviewOrientation:[[UIApplication sharedApplication]statusBarOrientation]];
        [self.view.layer addSublayer:_imgView.layer];
        [self.view.layer addSublayer:_takeBtn.layer];
        [self.view.layer addSublayer:_countView.layer];
        [self.view.layer addSublayer:_backBtn.layer];
    }
    

}

- (IBAction)takePicture:(id)sender
{
    if (didTake == NO)
    {
        [self.countView startAnimating];
        [self performSelector:@selector(tkPhoto) withObject:nil afterDelay:3];
        self.takeBtn.enabled = NO;
    }
   else
   {
       self.imgView.image = [UIImage createImageWithColor:CLEAR_COLOR];
       [self.camera startRunning];
       self.countView.hidden = NO;
       [self.countView stopAnimating];
       didTake = NO;
   }
}


- (IBAction)back:(id)sender
{
    if (didTake)
    {
        [self.delegate backFromCaptureViewControllerWithImage:self.camera.image];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tkPhoto
{
    self.takeBtn.enabled = YES;
    self.countView.hidden = YES;
    [self.camera CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
}


- (void)getImage
{
    self.imgView.image = self.camera.image;
  //  DLog(@"orentation = %d",self.imgView.image.imageOrientation);
    didTake = YES;
    [self.camera stopRunning];
    self.camera = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect rect = CGRectZero;
    if (toInterfaceOrientation == (UIInterfaceOrientationLandscapeRight))
    {
        
        rect = CGRectMake(0, 0, 1024, 768);
        
    }
    else 
    {
       
         rect = CGRectMake(0, 0, 768, 1024);
    }
    self.camera.frame = rect;
     [self.camera changePreviewOrientation:toInterfaceOrientation];
    
    
    DLog(@"frame = %@",NSStringFromCGRect(self.view.frame));
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
