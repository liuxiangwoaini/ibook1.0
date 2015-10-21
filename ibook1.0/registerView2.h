//
//  registerView2.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol registerView2Delagate <NSObject>

@optional
- (void)signatureTextfieldBeginedit;
- (void)signatureTextfieldEndedit;
- (void)sendVerificationBtnClick;
@end
@interface registerView2 : UIView
@property (weak, nonatomic) id<registerView2Delagate> delegate;
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
@property (assign, nonatomic, getter=isSend) BOOL send;
@end
