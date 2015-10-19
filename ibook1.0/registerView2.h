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
@end
@interface registerView2 : UIView
@property (weak, nonatomic) id<registerView2Delagate> delegate;
@end
