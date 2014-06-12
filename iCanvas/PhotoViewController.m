 //
//  PhotoViewController.m
//  iCanvas
//
//  Created by YANGRui on 13-11-10.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "PhotoViewController.h"
#import "SwipeView.h"
#import <MessageUI/MessageUI.h>
#import "GRRequestsManager.h"
@interface PhotoViewController ()<SwipeViewDataSource,SwipeViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,GRRequestsManagerDelegate>

{
   
    SwipeView  *_swipView;
    IBOutlet UIView *bar;
    NSInteger currentIndex;
    IBOutlet UILabel *titleLabel;
    NSMutableArray *dataArray;
    IBOutlet UIButton *shareButton;

}
@property (strong , nonatomic) GRRequestsManager *requestsManager;
- (IBAction)back:(id)sender;

- (IBAction)share:(id)sender;

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:CACH_DOCUMENTS_PATH(@"photo.plist")];
        if (dataArray == nil)
        {
            dataArray = [NSMutableArray array];
        }
        
        currentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupViews
{
    
   
    CGFloat h = 768-44-20;
    CGFloat w = 1024;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        h = 1024-44-20;
        w = 768;
    }
    // _swipView.frame = CGRectMake(0, 44, 768, 1024-44-20);
    _swipView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 44, w, h)];
    _swipView.dataSource = self;
    _swipView.delegate = self;
    _swipView.alignment = SwipeViewAlignmentCenter;
    _swipView.pagingEnabled = YES;
    _swipView.wrapEnabled = YES;
    _swipView.itemsPerPage = 1;
    _swipView.truncateFinalPage = YES;
    _swipView.backgroundColor = BLACK_COLOR;
    [self.view addSubview:_swipView];
    
    if (dataArray.count == 0)
    {
        _swipView.userInteractionEnabled = NO;
        shareButton.enabled = NO;
        
    }
    else
    {
        _swipView.userInteractionEnabled = YES;
        shareButton.enabled = YES;
    }
    titleLabel.text = [NSString stringWithFormat:@"当前共有%d张图片",(int)dataArray.count];
    
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [dataArray count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
   // YRZoomingView *zoomingView = (YRZoomingView *)view;
    UIImageView *zoomingView = (UIImageView *)view;
    //create or reuse view
    if (zoomingView == nil)
    {
        zoomingView = [[UIImageView alloc] initWithFrame:swipeView.bounds];
        
    }
    zoomingView.contentMode = UIViewContentModeScaleAspectFit;
    zoomingView.tag = index;
    NSDictionary *dict = dataArray[index];
    NSString *file = [dict objectForKey:@"picture"];
    [zoomingView imageFromFile:file];
    return zoomingView;
    
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    //update page control page
 
    currentIndex = swipeView.currentItemIndex;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
   // NSInteger index = swipeView.currentPage;
  //  YRZoomingView *view = (YRZoomingView *)[swipeView itemViewAtIndex:index];
    // DLog(@"view = %@",[view class]);
    //[view setZoomScale:1.0 animated:YES];
    //currentIndex = swipeView.currentItemIndex;
       
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        _swipView.frame = CGRectMake(0, 44, 768, 1024-44-20);
    }
    else
    {
        _swipView.frame = CGRectMake(0, 44, 1024, 768-44-20);
    }
    [_swipView layoutSubviews];
}


- (IBAction)share:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"发送至电脑",@"发邮件",@"保存到相册",nil];
    [as showFromRect:btn.bounds inView:btn animated:YES];
}

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
    if(buttonIndex == 2)
    {
        [self saveToAblum];
    }
}



- (void)sendMail
{
    NSDictionary *dict = dataArray[currentIndex];
    NSString *str = [dict objectForKey:@"picture"];
    UIImage *img = [UIImage imageWithContentsOfFile:str];
    NSData *data = UIImagePNGRepresentation(img);
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:@"分享图片"];
        [mailVC addAttachmentData:data mimeType:@"image/png" fileName:@"picture.png"];
        [self presentViewController:mailVC animated:YES completion:nil];
    }

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
    
    self.requestsManager = [[GRRequestsManager alloc] initWithHostname:url
                                                                  user:uid                                                              password:pw];
    self.requestsManager.delegate = self;
//    [self.requestsManager addRequestForCreateDirectoryAtPath:@"failed-sign/"];
//    [self.requestsManager addRequestForCreateDirectoryAtPath:@"failed-template/"];
//    [self.requestsManager addRequestForCreateDirectoryAtPath:@"failed-photo/"];
//    [self.requestsManager startProcessingRequests];

}


#pragma mark - 上传到FTP
- (void)uploadToFTP
{
    
    [self _setupManager];
    [self showMBLoadingWithMessage:@"上传中..."];
    NSDictionary *dict = dataArray[currentIndex];

    NSString *photoPath = [dict objectForKey:@"photo"];
    NSString *signPath = [dict objectForKey:@"sign"];
    NSString *picturePath = [dict objectForKey:@"picture"];
    
    NSString *path = [self timeStampAsString];
    NSString * p1 = [NSString stringWithFormat:@"photo%@",path];
    NSString * p2 = [NSString stringWithFormat:@"sign%@",path];
    NSString * p3 = [NSString stringWithFormat:@"picture%@",path];
    
    NSString *remotepath1 = [NSString stringWithFormat:@"photo/%@",p1];
    NSString *remotepath2 = [NSString stringWithFormat:@"sign/%@",p2];
    NSString *remotepath3 = [NSString stringWithFormat:@"template/%@",p3];
    [self.requestsManager addRequestForUploadFileAtLocalPath:photoPath  toRemotePath:remotepath1];
    [self.requestsManager addRequestForUploadFileAtLocalPath:signPath   toRemotePath:remotepath2];
    [self.requestsManager addRequestForUploadFileAtLocalPath:picturePath  toRemotePath:remotepath3];
    [self.requestsManager startProcessingRequests];
}


- (void)saveToAblum
{
    NSDictionary *dict = dataArray[currentIndex];
    NSString *picturePath = [dict objectForKey:@"picture"];
    UIImage *img = [UIImage imageWithContentsOfFile:picturePath];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    [self showMBCompletedWithMessage:@"保存成功!"];
}


#pragma mark -MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:Nil];
}


- (NSString *)timeStampAsString
{
    
    ///DLog(@"data = %@",[NSDate date]);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd-hh-mm-ss.SSS"];
    NSString *str = [df stringFromDate:[NSDate date]];
    NSString *new = [NSString stringWithFormat:@"iPad%@.png",str];
    return new;
}


- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request
{
    static int i = 0;
    i++;
    if (i%3 == 0)
    {
        [self hideMBLoading];
        [self showMBCompletedWithMessage:@"上传成功"];
        //[self hideMBLoading];
        i = 0;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
