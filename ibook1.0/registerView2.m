//
//  registerView2.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "registerView2.h"
@interface registerView2()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timeindex;
- (IBAction)sendVerification;

@end
@implementation registerView2

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCall:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeindex = 60;
    //    self.sendVerificationBtn.titleLabel.text = @"发送验证码";
    
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
- (IBAction)sendVerification {
    
    if ([self.delegate respondsToSelector:@selector(sendVerificationBtnClick)]) {
        [self.delegate sendVerificationBtnClick];
    }
    
    if (self.send) {
        self.sendVerificationBtn.enabled = NO;
        self.timer.fireDate = [NSDate date];
    }
}

- (void)timerCall:(NSTimer *)time
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.sendVerificationBtn setTitle:[NSString stringWithFormat:@"还剩%d秒", self.timeindex] forState:UIControlStateDisabled];
    }];
    self.timeindex -= 1;
    if (self.timeindex == 0) {
        self.sendVerificationBtn.enabled = YES;
        self.sendVerificationBtn.titleLabel.text = @"再次发送";
        [self.timer invalidate];
        self.timer = nil;
        self.timeindex = 60;
    }
}
@end
