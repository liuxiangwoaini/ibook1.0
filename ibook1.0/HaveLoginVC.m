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
@interface HaveLoginVC ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headview;
- (IBAction)logout;

@end

@implementation HaveLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}





- (IBAction)logout {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"真的要注销吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
    [action showInView:self.view];
    
    [AVUser logOut];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showSuccess:@"注销成功"];
        [AVUser logOut];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
