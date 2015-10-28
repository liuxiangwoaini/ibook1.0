//
//  HaveLoginVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "HaveLoginVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "iBookUser.h"
#import "SDWebImageDownloader.h"
#import "PersonDataVC.h"
#import "PersonActivityVC.h"

@interface HaveLoginVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headview;
@property (weak, nonatomic) IBOutlet UITableView *persontable;
@property (strong ,nonatomic) NSMutableArray *datas;


@end

@implementation HaveLoginVC
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        [_datas addObject:@"个人资料"];
        [_datas addObject:@"发起的活动"];
        [_datas addObject:@"报名的活动"];
        [_datas addObject:@"结束的活动"];
        [_datas addObject:@"注销"];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.persontable.dataSource = self;
    self.persontable.delegate  =self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self sethead];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)sethead
{
    AVUser *user = [AVUser currentUser];
    ;
        self.headview.image = [self circleImage:[UIImage imageNamed:@"avatar_default.png"] withParam:1];
//    iBookUser *u = [[iBookUser alloc] initwithdict:dict];
//    NSLog(@"%@---%@", dict[@"nickname"],user);
    NSString *url = [NSString stringWithFormat:@"%@", user[@"avatarUrl"]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cacheType  = SDImageCacheTypeDisk;
        if (finished) {
            UIImage *image1 = [self circleImage:image withParam:1];
            self.headview.image = image1;
        }
    }];
    

//    [self.headview sd_setImageWithURL:[NSURL URLWithString:url]];


}



-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showSuccess:@"注销成功"];
        [AVUser logOut];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"xixi";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =self.datas[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            PersonDataVC *vc = [[PersonDataVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            
            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            
            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            
            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"真的要注销吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
            [action showInView:self.view];
            
            break;
        }
    }
}

@end
