//
//  YRRootViewController.m
//  iCanvas
//
//  Created by 杨锐 on 13-8-17.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "YRRootViewController.h"
#import "SwipeView.h"
#import "SettingViewController.h"
#import "PhotoViewController.h"
#import "DrawingView.h"
#import "TemplateViewController.h"
@interface YRRootViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SettingViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,FTPHelperDelegate,TemplateViewControllerDelegate,GRRequestsManagerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    SBPageFlowView  *_flowView;
    IBOutlet UIView *bar;
    IBOutlet UIButton *takeButton;
    DrawingView *drawingView;
    
    NSString *photoPath;
    NSString *signPath;
    NSString *picturePath;
    
    NSInteger time;
    NSTimer *timer;
}

@property (strong , nonatomic) GRRequestsManager *requestsManager;

- (IBAction)changeTemplate:(id)sender;

- (IBAction)settings:(id)sender;

- (IBAction)share:(id)sender;

- (IBAction)openCamera:(id)sender;

- (IBAction)clear:(id)sender;

- (IBAction)takePicture:(id)sender;

@end

@implementation YRRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:CACH_DOCUMENTS_PATH(@"photo.plist")];
        if (_dataArray == nil)
        {
            _dataArray = [NSMutableArray array];
        }
        time = 0;
        //DLog(@"_dataArray = %@",_dataArray);
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_COLOR;
    
    
    drawingView = [[DrawingView alloc] initWithFrame:CGRectMake(0, 44, 1024, 748-44)];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        drawingView.frame = CGRectMake(0, 44, 768, 1024-44-20);
      //  [AppTool storeObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
        
    
    DLog(@"app heigth = %f",APP_WIDTH);
   // bar.frame = CGRectMake(0, APP_WIDTH-44, APP_HEIGHT, 44);
    [self.view insertSubview:drawingView atIndex:0];
    
    takeButton.hidden = YES;
}



- (IBAction)settings:(id)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    settingVC.delegate = self;
    [settingVC showInViewController:self];
}

- (IBAction)share:(id)sender
{
    [self uploadToFTP];
}

- (IBAction)openCamera:(id)sender
{
    NSString *status = [AppTool getObjectForKey:@"noPrompt"];
    if (![status isEqualToString:@"YES"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确定您的模板是透明的" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"不在提示" ,nil];
        [alert show];

    }
    else
    {
        [drawingView openCamera];
        [self hideButtons];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //dongnothon
    }
    else if (buttonIndex == 1)
    {
         [drawingView openCamera];
        [self hideButtons];
    }
    else
    {   [drawingView openCamera];
        [AppTool storeObject:@"YES" forKey:@"noPrompt"];
        [self hideButtons];
    }
   // DLog(@"index = %d",buttonIndex);
}

- (void)hideButtons
{
    for (UIView *views in bar.subviews)
    {
        if ([views isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)views;
            if (btn.tag != 100)
            {
                btn.hidden = YES;
            }
        }
    }
    takeButton.hidden = NO;
}

- (void)showButtons
{
    for (UIView *views in bar.subviews)
    {
        if ([views isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)views;
            if (btn.tag == 100)
            {
                btn.hidden = YES;
            }
            else
            {
                btn.hidden = NO;
            }
        }

    }
}



- (IBAction)clear:(id)sender
{
    [drawingView clear];
   
}


- (IBAction)changeTemplate:(id)sender
{
    
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (void)showTemplate
{
    TemplateViewController *templateVC = [[TemplateViewController alloc] initWithNibName:@"TemplateViewController" bundle:nil];
    templateVC.delegate = self;
    [self.navigationController pushViewController:templateVC animated:YES];
}

- (IBAction)takePicture:(id)sender
{
    [drawingView takePicture];
    [self showButtons];
}

#pragma mark - 合成图片


- (UIImage *)imageFromView: (UIView *)theView  atFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}


#pragma mark - SettingViewController delegate method

- (void)setLineWidth:(CGFloat)witth andColor:(NSString *)color
{
    drawingView.signView.fontWidth = (int)witth;
    NSArray *arr = [color componentsSeparatedByString:@","];
    int red =   [arr[0] intValue];
    int green = [arr[1] intValue];
    int blue =  [arr[2] intValue];
    drawingView.signView.color = GLKColor(red, green, blue);
   
}




#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    drawingView.image = img;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIActionSheet Delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self uploadToFTP];
    }
    if (buttonIndex == 1)
    {
        [self sendMail];
    }
    if (buttonIndex == 2)
    {
        [self saveToAlbum];
    }
   // DLog(@"butonIndex = %d",buttonIndex);
}


- (void)_setupManager
{
    NSString *server = [AppTool getObjectForKey:SERVER];
    if(server.length == 0)
    {
       [AppTool showAlert:@"提示" message:@"还未设置FTP服务器"];
        return;
    }
    NSString *port = [AppTool getObjectForKey:PORT];
    NSString *uid = [AppTool getObjectForKey:kUID];
    NSString *pw = [AppTool getObjectForKey:PASSWORD];
    
    NSString *url = nil;
    if(![server hasPrefix:@"ftp://"])
    {
        url = [NSString stringWithFormat:@"ftp://%@:%@",server,port];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@:%@",server,port];
    }

    if (self.requestsManager == nil)
    {
        self.requestsManager = [[GRRequestsManager alloc] initWithHostname:url
                                                                      user:uid
                                                                  password:pw];
        self.requestsManager.delegate = self;

    }
}


#pragma mark - 上传到FTP
- (void)uploadToFTP
{
    
    NSString *path1 = [self timeStampAsStringWithSuffix:@"png"];
    NSString *path2 = [self timeStampAsStringWithSuffix:@"jpg"];
    photoPath = [NSString stringWithFormat:@"photo%@",path2];
    signPath = [NSString stringWithFormat:@"sign%@",path1];
    picturePath = [NSString stringWithFormat:@"picture%@",path1];
    [self _setupManager];
    
    NSString *server = [AppTool getObjectForKey:SERVER];
    if(server.length == 0)
    {
        return;
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
    
    [self showMBLoadingWithMessage:@"上传中..."];
    UIImage *photo = drawingView.imgView.image;
    CGRect rect = [drawingView getSignRect];
    UIImage *sign = [drawingView.signView.signatureImage getSubImage:rect];
   // DLog(@"sign = %@",sign);
  
    if (sign == nil)
    {
        sign = [UIImage createImageWithColor:CLEAR_COLOR];
    }
    UIImage *picture = [self imageFromView:drawingView atFrame:drawingView.bounds];
    
    NSData *photoData = UIImageJPEGRepresentation(photo, 0.1/2);//(photo);
    NSData *signData = UIImagePNGRepresentation(sign);//(sign,0.5);
    NSData *pictureData = UIImagePNGRepresentation(picture);//(picture, 0.5);
    
    [photoData writeToFile:CACH_DOCUMENTS_PATH(photoPath) atomically:YES];
    [signData writeToFile:CACH_DOCUMENTS_PATH(signPath) atomically:YES];
    [pictureData writeToFile:CACH_DOCUMENTS_PATH(picturePath) atomically:YES];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:CACH_DOCUMENTS_PATH(photoPath) forKey:@"photo"];
    [dict setObject:CACH_DOCUMENTS_PATH(signPath) forKey:@"sign"];
    [dict setObject:CACH_DOCUMENTS_PATH(picturePath) forKey:@"picture"];
    [_dataArray addObject:dict];
    [NSKeyedArchiver archiveRootObject:_dataArray toFile:CACH_DOCUMENTS_PATH(@"photo.plist")];

    
    NSString *remotepath1 = [NSString stringWithFormat:@"photo/%@",photoPath];
    NSString *remotepath2 = [NSString stringWithFormat:@"sign/%@",signPath];
    NSString *remotepath3 = [NSString stringWithFormat:@"template/%@",picturePath];
    
    NSString *uploadPhoto = [AppTool getObjectForKey:@"uploadPhoto"];
    if (![uploadPhoto isEqualToString:@"NO"])
    {
         [self.requestsManager addRequestForUploadFileAtLocalPath:CACH_DOCUMENTS_PATH(photoPath)  toRemotePath:remotepath1];
    }
    NSString *uploadSign = [AppTool getObjectForKey:@"uploadSign"];
    if (![uploadSign isEqualToString:@"NO"])
    {
        
        [self.requestsManager addRequestForUploadFileAtLocalPath:CACH_DOCUMENTS_PATH(signPath)  toRemotePath:remotepath2];

    }
    NSString *uploadTemplate = [AppTool getObjectForKey:@"uploadTemplate"];
    if (![uploadTemplate isEqualToString:@"NO"])
    {
        
        [self.requestsManager addRequestForUploadFileAtLocalPath:CACH_DOCUMENTS_PATH(picturePath)  toRemotePath:remotepath3];
    }
    [self.requestsManager startProcessingRequests];
}

#pragma mark - FTP 代理方法

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request
{
        [self hideMBLoading];
        [self showMBCompletedWithMessage:@"上传成功"];
        [timer invalidate];
        time = 0;
        [drawingView clear];
    
}

- (void)timeOut:(NSTimer *)t
{
    time ++;
    NSString *timeOut = [AppTool getObjectForKey:@"timeOut"];
    if (timeOut.length == 0)
    {
        timeOut = @"15";
    }
    if (time>timeOut.intValue)
    {
        time = 0;
        [timer invalidate];
        [self hideMBLoading];
        [self showMBFailedWithMessage:@"超时,请稍后再试"];
    }
}



- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error
{
    DLog(@"error code = %@",error.userInfo);
    time = 0;
    [timer invalidate];
    NSString *str = [error.userInfo objectForKey:@"message"];
    if (![str isEqualToString:@"Can't overwrite directory!"])
    {
        
    }
    if ([str isEqualToString:@"Unknown error!"])
    {
        [self hideMBLoading];
        [self showMBFailedWithMessage:@"请检查FTP设置"];
        //[self hideMBLoading];
    }
    
    if ([str isEqualToString:@"Not logged in."])
    {
        [self hideMBLoading];
        [self showMBFailedWithMessage:@"用户名错误或密码错误"];
    }
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailWritingFileAtPath:(NSString *)path forRequest:(id<GRDataExchangeRequestProtocol>)request error:(NSError *)error
{
    DLog(@"123");
}




#pragma mark - 保存到相册

- (void)saveToAlbum
{
    UIImage *img = drawingView.signView.signatureImage;//[self imageFromView:drawingView atFrame:drawingView.bounds];
    NSData *data = UIImagePNGRepresentation(img);
    [data writeToFile:DOCUMENTS_PATH(@"123.png") atomically:YES];
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    [self showMBCompletedWithMessage:@"保存成功"];
}




#pragma mark - 发送邮件

- (void)sendMail
{
    UIImage *img = [self imageFromView:drawingView atFrame:drawingView.bounds];
    NSData *data = UIImagePNGRepresentation(img);
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:@"分享图片"];
        [mailVC addAttachmentData:data mimeType:@"image/png" fileName:[self timeStampAsStringWithSuffix:@"png"]];
        [self presentViewController:mailVC animated:YES completion:nil];

    }
}


#pragma mark -MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:Nil];
}

- (NSString *)timeStampAsStringWithSuffix:(NSString *)suffix
{
 
    ///DLog(@"data = %@",[NSDate date]);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd-hh-mm-ss.SSS"];
    NSString *str = [df stringFromDate:[NSDate date]];
    NSString *new = [NSString stringWithFormat:@"iPad%@.%@",str,suffix];
    return new;
}

#pragma mark - 控制屏幕旋转方向


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        drawingView.frame = CGRectMake(0, 44, 768, 1004-44);
        takeButton.frame = CGRectMake(768-30-20, 7, 30, 30);
    }
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        drawingView.frame = CGRectMake(0, 44, 1024, 748-44);
        takeButton.frame = CGRectMake(962, 7, 30, 30);
    }
    [drawingView changeOrientation:toInterfaceOrientation];
}


#pragma mark - Template View Controller delegate method

- (void)passImage:(UIImage *)img
{
    
    if (img)
    {
        drawingView.templateView.image = img;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
