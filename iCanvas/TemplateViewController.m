//
//  TemplateViewController.m
//  iCanvas
//
//  Created by YANGRui on 13-11-11.
//  Copyright (c) 2013年 yangrui. All rights reserved.
//

#import "TemplateViewController.h"

@interface TemplateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
  IBOutlet  UITableView *_tableView;
    IBOutlet UIView *bar;
    NSMutableArray *dataArray;
}
- (IBAction)back:(id)sender;

@end

@implementation TemplateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataArray = [NSMutableArray array];
        NSArray *arr = [[YRFileManager sharedYRFileManager] getAllFilesInDocumentsDirectory];
        // DLog(@"arr = %@",arr);
        for (NSString *file in arr)
        {
            [dataArray addObject:file];
        }
        DLog(@"dataArray = %@",dataArray);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupwiews];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated

{
    
//    [super viewWillAppear:animated];
//    
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//    
//    [UIView beginAnimations:nil context:nil];
//    
//    [UIView setAnimationDuration:duration];
//    
//    self.navigationController.view.transform = CGAffineTransformIdentity;
//    
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI*(90)/180.0);
//    
//    self.navigationController.view.bounds = CGRectMake(0, 0, 1024, 768);
//    
//    [UIView commitAnimations];
//    
//    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:YES];
    
}

- (void)setupwiews
{
     NSInteger version = [[[UIDevice currentDevice] systemVersion] integerValue];
    if (version >= 7)
    {
        bar.frame = CGRectMake(0, 20, 1024, 44);
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
        headView.backgroundColor = bar.backgroundColor;
        [self.view addSubview:headView];
        
        _tableView.frame = CGRectMake(0, 64, 1024, 1024-64);
    }
}


- (IBAction)back:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(passImage:)])
    {
        [self.delegate passImage:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];

    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
   // [cell.imageView imageFromFile:dataArray[indexPath.row]];
    NSString *path = dataArray[indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    cell.textLabel.text = [NSString stringWithFormat:@"模板%d",(int)indexPath.row+1];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = cell.imageView.image;
    if ([self.delegate respondsToSelector:@selector(passImage:)])
    {
        [self.delegate passImage:image];
    }
    NSString *file = dataArray[indexPath.row];
    [AppTool storeObject:file forKey:@"template"];
    [self.navigationController popViewControllerAnimated:YES];
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == UIInterfaceOrientationMaskLandscape);
//}



@end
