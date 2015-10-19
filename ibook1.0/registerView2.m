//
//  registerView2.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "registerView2.h"
@interface registerView2()<UITextFieldDelegate>
/**
 *验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *Verificationcode;
/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UITextField *nickname;
/**
 签名
 */
@property (weak, nonatomic) IBOutlet UITextField *signature;

@end
@implementation registerView2

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.Verificationcode.delegate  =self;
    self.nickname.delegate  =self;
    self.signature.delegate  =self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [self.nickname becomeFirstResponder];
    }else if (textField.tag == 1)
    {
        [self.signature becomeFirstResponder];
    }else
    {
        [self endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%d", textField.tag);
    if (textField.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(signatureTextfieldBeginedit)]) {
            [self.delegate signatureTextfieldBeginedit];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        if ([self.delegate respondsToSelector:@selector(signatureTextfieldEndedit)]) {
            [self.delegate signatureTextfieldEndedit];
        }
    }
}
@end
