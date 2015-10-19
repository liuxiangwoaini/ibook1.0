//
//  registerView1.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "registerView1.h"
@interface registerView1()<UITextFieldDelegate>
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *username;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwd;
/**
 *    确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passwdagain;
@end

@implementation registerView1

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.passwdagain.delegate  =self;
    self.username.delegate  =self;
    self.passwd.delegate  =self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [self.passwd becomeFirstResponder];
    }else if (textField.tag == 1)
    {
        [self.passwdagain becomeFirstResponder];
    }else
    {
        [self endEditing:YES];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(PasswdagainTextfieldBeginedit)]) {
            [self.delegate PasswdagainTextfieldBeginedit];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(PasswdagainTextfieldEndedit)]) {
            [self.delegate PasswdagainTextfieldEndedit];
        }
    }
}


@end
