//
//  NotLoginVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "NotLoginVC.h"
#import "MBProgressHUD+MJ.h"
#import "registeredVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HaveLoginVC.h"
@interface NotLoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
/**
 *  登陆
 */
- (IBAction)login;
/**
 *  注册
 */
- (IBAction)regis;
/**
 *  忘记密码
 */
- (IBAction)forgetpasswd;

@end

@implementation NotLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    self.passwd.delegate = self;
    
    
    
    
}




- (IBAction)login {
    if (!self.username.text.length) {
        [MBProgressHUD showError:@"没有用户名"];
        return;
    }else if (!self.passwd.text.length)
    {
        [MBProgressHUD showError:@"没有密码"];
        return;
    }
    
    [AVUser logInWithUsernameInBackground:self.username.text password:self.passwd.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [MBProgressHUD showSuccess:@"登陆成功,正在跳转..."];
            HaveLoginVC *vc = [[HaveLoginVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
//            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [MBProgressHUD showError:@"登陆失败"];
        }
    }];
    

}

/**
 触摸开始时停止编辑状态
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)regis {
    registeredVC *vc = [[registeredVC alloc] init];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)forgetpasswd {
}

/**
    textfield代理方法，用来监听return键的点击,textfield绑定了tag，
    用户名为0， 密码为1
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
        {
            [self.passwd becomeFirstResponder];
            break;
        }
            
            
            
        default:
        {
            [self.view endEditing:YES];
            [self login];
            break;
        }
            
    }
    return YES;
}


@end
