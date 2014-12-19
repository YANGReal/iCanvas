//
//  SettingViewController.m
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "SettingViewController.h"
#import "GRListingRequest.h"
#import "TemplateViewController.h"
@interface SettingViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,GRRequestsManagerDelegate,TemplateViewControllerDelegate,UIAlertViewDelegate>
{
   IBOutlet UITextField *serverTextField;
   IBOutlet UITextField *portTextField;
   IBOutlet UITextField *userNameTextField;
   IBOutlet UITextField *passwordTextField;
   IBOutlet UIPickerView *_picker;
   IBOutlet UISlider *slider;
   IBOutlet UIView *bgView;
   IBOutlet UIView *selectedColorView;
   // KZColorPicker *colorPicker;
    
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    IBOutlet UIButton *button3;
    NSString *penColor;
    
    NSArray *colorArray;
    NSArray *colorStrArr;
    
    IBOutlet UISlider *timeSlider;
    IBOutlet UILabel *timeOutLabel;
    
    
    IBOutlet UIButton *frontBtn;
    IBOutlet UIButton *backBtn;
    
    
    IBOutlet UISwitch *switcher;
    
    IBOutlet UISwitch *penSwitch;
    
     IBOutlet UISwitch *uploadSwitch;
    
}

@property (strong , nonatomic) GRRequestsManager *requestsManager;

- (IBAction)save:(id)sender;
- (IBAction)back:(id)sender;

- (IBAction)lineWidth:(id)sender;

- (IBAction)chooseTemplate:(id)sender;


- (IBAction)button1Clicked:(id)sender;
- (IBAction)button2Clicked:(id)sender;
- (IBAction)button3Clicked:(id)sender;

- (IBAction)timeOut:(id)sender;


- (IBAction)frontBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

- (IBAction)openCountdown:(UISwitch *)sender;

- (IBAction)penSwitch:(UISwitch *)sender;
- (IBAction)uploadSwitch:(UISwitch *)sender;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        penColor = @"0,0,0";
        
        colorArray = @[[UIColor blackColor],[UIColor whiteColor],
                       [UIColor grayColor],[UIColor redColor],
                       [UIColor greenColor],[UIColor blueColor],
                       [UIColor cyanColor],[UIColor yellowColor],
                       [UIColor magentaColor],[UIColor orangeColor],
                       [UIColor purpleColor],[UIColor brownColor]];
        
        colorStrArr = @[@"0,0,0",@"255,255,255",@"128,128,128",@"255,0,0",@"0,255,0",@"0,0,255",@"0,255,255",@"255,255,0",@"255,0,255",@"255,128,0",@"128,0,128",@"153,102,51"];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *width = [AppTool getObjectForKey:@"width"];
    slider.value = width.floatValue;
    DLog(@"value = %f",slider.value);
    if (width.length == 0)
    {
        slider.value = 5.0;
    }
    
    NSString *colorIndex = [AppTool getObjectForKey:@"color"];
    if (colorIndex.length == 0)
    {
        [_picker selectRow:0 inComponent:0 animated:YES];
        penColor = @"0,0,0";
        selectedColorView.backgroundColor = BLACK_COLOR;
    }
    else
    {
        NSInteger index = colorIndex.integerValue;
        DLog(@"index = %ld",index);
        [_picker selectRow:index inComponent:0 animated:YES];
        penColor = colorStrArr[index];
        NSArray *arr = [penColor componentsSeparatedByString:@","];
        int red = [arr[0] intValue];
        int green = [arr[1] intValue];
        int blue = [arr[2] intValue];
        selectedColorView.backgroundColor = RGBColor(red, green, blue, 1);
    }
    
    NSString *server = [AppTool getObjectForKey:SERVER];
    if (server.length != 0)
    {
        serverTextField.text = server;
    }
    NSString *port = [AppTool getObjectForKey:PORT];
    if (port.length != 0)
    {
        portTextField.text = port;
    }

    NSString *uid = [AppTool getObjectForKey:kUID];
    if (uid.length != 0)
    {
        userNameTextField.text = uid;
    }
    
    NSString *pw = [AppTool getObjectForKey:PASSWORD];
    if (pw.length != 0)
    {
        passwordTextField.text = pw;
    }
    
    
    NSString *uploadPhoto = [AppTool getObjectForKey:@"uploadPhoto"];
    if (![uploadPhoto isEqualToString:@"NO"])
    {
        button1.selected = YES;
    }
    else
    {
        button1.selected = NO;
    }
    NSString *uploadSign = [AppTool getObjectForKey:@"uploadSign"];
    if (![uploadSign isEqualToString:@"NO"])
    {
        button2.selected = YES;
    }
    else
    {
        button2.selected = NO;
    }
    NSString *uploadTemplate = [AppTool getObjectForKey:@"uploadTemplate"];
    if (![uploadTemplate isEqualToString:@"NO"])
    {
        button3.selected = YES;
    }
    else
    {
        button3.selected = NO;
    }

    NSString *time = [AppTool getObjectForKey:@"timeOut"];
    if (time.length == 0)
    {
        time = @"15";
    }
    timeSlider.value = time.intValue;
    timeOutLabel.text = [NSString stringWithFormat:@"%@秒",time];
    
    NSString *front = [AppTool getObjectForKey:@"front"];
    if ([front isEqualToString:@"YES"])
    {
        frontBtn.selected = YES;
    }
    else
    {
        backBtn.selected = YES;
    }
    
    NSString *countDown = [AppTool getObjectForKey:@"countDown"];
    if (![countDown isEqualToString:@"NO"])
    {
        switcher.on = YES;
    }
    else
    {
        switcher.on = NO;
    }
    
    NSString *pen  = [AppTool getObjectForKey:@"pen"];
    if (![pen isEqualToString:@"NO"])
    {
        penSwitch.on = YES;
    }
    else
    {
        penSwitch.on = NO;
    }
    NSString *upload = [AppTool getObjectForKey:@"upload"];
    if (![upload isEqualToString:@"NO"])
    {
        uploadSwitch.on = YES;
    }
    else
    {
        uploadSwitch.on = NO;
    }

}

- (IBAction)chooseTemplate:(id)sender
{
   // [self.parentViewController performSelector:@selector(showTemplate)];
    TemplateViewController *vc = [[TemplateViewController alloc] initWithNibName:@"TemplateViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)openCountdown:(UISwitch *)sender
{
    if (sender.on)
    {
        [AppTool storeObject:@"YES" forKey:@"countDown"];
    }
    else
    {
        [AppTool storeObject:@"NO" forKey:@"countDown"];
    }
   
   // DLog(@"on = %d",sender.on);
}


- (IBAction)penSwitch:(UISwitch *)sender
{
    if (sender.on)
    {
         [AppTool storeObject:@"YES" forKey:@"pen"];
    }
    else
    {
        [AppTool storeObject:@"NO" forKey:@"pen"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"需要退出软件重新启动"
                                                   delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"立即退出", nil];
    [alert show];
}

- (void)passImage:(UIImage *)img
{
    
}

- (IBAction)uploadSwitch:(UISwitch *)sender
{
    if (sender.on)
    {
        [AppTool storeObject:@"YES" forKey:@"upload"];
    }
    else
    {
        [AppTool storeObject:@"NO" forKey:@"upload"];
    }
}



- (void)dismiss
{
    [self hideMBLoading];
    UIView *maskView = [self.view.superview viewWithTag:-100];
   // [UIView animateWithDuration:<#(NSTimeInterval)#> animations:<#^(void)animations#>]
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0.0;
        
       //  self.view.center = CGPointMake(512, 1200);
        
        if (self.parentViewController.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            self.view.center = CGPointMake(768/2, 2000);
        }
        else
        {
             self.view.center = CGPointMake(512, 1200);
        }
        
    } completion:^(BOOL finished) {
        
        [maskView removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)save:(id)sender
{
    if ([self checkInput])
    {
        [AppTool storeObject:serverTextField.text forKey:SERVER];
        [AppTool storeObject:portTextField.text forKey:PORT];
        [AppTool storeObject:userNameTextField.text forKey:kUID];
        [AppTool storeObject:passwordTextField.text forKey:PASSWORD];
        if ([self.delegate respondsToSelector:@selector(setLineWidth:andColor:)])
        {
            [self.delegate setLineWidth:slider.value andColor:penColor];
        }
        [self setupFTPServer];
        //[self dismiss];
        [self showMBLoadingWithMessage:@"稍等..."];
        [self performSelector:@selector(back:) withObject:nil afterDelay:4];

    }
    
    
}
- (IBAction)back:(id)sender
{
    [self.delegate setLineWidth:slider.value andColor:penColor];
    [self.navigationController popViewControllerAnimated:YES];
    return;
    [self dismiss];
}

- (IBAction)lineWidth:(id)sender
{
   // DLog(@"value = %f",slider.value);
    NSString *str = [NSString stringWithFormat:@"%f",slider.value];
    [AppTool storeObject:str forKey:@"width"];
}



- (IBAction)button1Clicked:(id)sender
{
    NSString *uploadPhoto = [AppTool getObjectForKey:@"uploadPhoto"];
    if (![uploadPhoto isEqualToString:@"NO"])
    {
        button1.selected = NO;
        [AppTool storeObject:@"NO" forKey:@"uploadPhoto"];
    }
    else
    {
        button1.selected = YES;
         [AppTool storeObject:@"YES" forKey:@"uploadPhoto"];
    }

}
- (IBAction)button2Clicked:(id)sender
{
    NSString *uploadSign = [AppTool getObjectForKey:@"uploadSign"];
    if (![uploadSign isEqualToString:@"NO"])
    {
        button2.selected = NO;
        [AppTool storeObject:@"NO" forKey:@"uploadSign"];
    }
    else
    {
        button2.selected = YES;
        [AppTool storeObject:@"YES" forKey:@"uploadSign"];
    }

}
- (IBAction)button3Clicked:(id)sender
{
    NSString *uploadTemplate = [AppTool getObjectForKey:@"uploadTemplate"];
    if (![uploadTemplate isEqualToString:@"NO"])
    {
        button3.selected = NO;
        [AppTool storeObject:@"NO" forKey:@"uploadTemplate"];
    }
    else
    {
        button3.selected = YES;
        [AppTool storeObject:@"YES" forKey:@"uploadTemplate"];
    }

}


- (IBAction)frontBtnClicked:(id)sender
{
    frontBtn.selected = YES;
    backBtn.selected = NO;
    [AppTool storeObject:@"YES" forKey:@"front"];
}
- (IBAction)backBtnClicked:(id)sender
{
    backBtn.selected = YES;
    frontBtn.selected = NO;
    [AppTool storeObject:@"NO" forKey:@"front"];
}


#pragma mark UIPickerView Delegate method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return colorArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *colorview = [[UIView alloc] init];
    colorview.backgroundColor = colorArray[row];
    return colorview;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *str = [NSString stringWithFormat:@"%d",(int)row];
    [AppTool storeObject:str forKey:@"color"];
    penColor = colorStrArr[row];
    NSArray *arr = [penColor componentsSeparatedByString:@","];
    int red =   [arr[0] intValue];
    int green = [arr[1] intValue];
    int blue =  [arr[2] intValue];
    selectedColorView.backgroundColor = RGBColor(red, green, blue, 1);
    [AppTool storeObject:penColor forKey:@"penColor"];
}

- (BOOL)checkInput
{
    if (serverTextField.text.length == 0)
    {
        [serverTextField becomeFirstResponder];
        [AppTool showAlert:@"提示" message:@"请输入FTP服务器地址"];
        return NO;
    }
    if (portTextField.text.length == 0)
    {
        [portTextField becomeFirstResponder];
        [AppTool showAlert:@"提示" message:@"请输入FTP端口号"];
        return NO;
    }
    if (userNameTextField.text.length == 0)
    {
        [userNameTextField becomeFirstResponder];
        [AppTool showAlert:@"提示" message:@"请输入FTP用户名"];
        return NO;
    }
    if (passwordTextField.text.length == 0)
    {
        [passwordTextField becomeFirstResponder];
        [AppTool showAlert:@"提示" message:@"请输入FTP密码"];
        return NO;
    }
    return YES;
}


- (IBAction)timeOut:(id)sender
{
    NSString *time = [NSString stringWithFormat:@"%d",(int)timeSlider.value];
    [AppTool storeObject:time forKey:@"timeOut"];
    timeOutLabel.text = [NSString stringWithFormat:@"%@秒",time];
}


#pragma mark - 设置ftp

- (void)setupFTPServer
{
    
    NSString *server = serverTextField.text;
    NSString *port = portTextField.text;
    NSString *pw = passwordTextField.text;
    NSString *uid = userNameTextField.text;
    NSString *url = nil;

    if(![server hasPrefix:@"ftp://"])
    {
        url = [NSString stringWithFormat:@"ftp://%@:%@",server,port];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@:%@",server,port];
    }
    

    self.requestsManager = [[GRRequestsManager alloc] initWithHostname:url
                                                                  user:uid
                                                              password:pw];
    self.requestsManager.delegate = self;
    
    [self.requestsManager addRequestForCreateDirectoryAtPath:@"sign/"];
    [self.requestsManager addRequestForCreateDirectoryAtPath:@"template/"];
    [self.requestsManager addRequestForCreateDirectoryAtPath:@"photo/"];
    [self.requestsManager startProcessingRequests];

}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteCreateDirectoryRequest:(id<GRRequestProtocol>)request
{
    DLog(@"创建目录成功");
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    {
        exit(0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
