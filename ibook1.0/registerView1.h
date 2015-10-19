//
//  registerView1.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol registerView1Delagate <NSObject>

@optional
- (void)PasswdagainTextfieldBeginedit;
- (void)PasswdagainTextfieldEndedit;
@end


@interface registerView1 : UIView
@property (weak, nonatomic) id<registerView1Delagate> delegate;
@end
