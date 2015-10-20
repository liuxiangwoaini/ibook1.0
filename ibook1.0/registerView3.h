//
//  registerView3.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerView3Delagate <NSObject>

@optional
- (void)choosebithday;
- (void)chooseschool;
@end
@interface registerView3 : UIView
@property (weak, nonatomic) id<registerView3Delagate> delegate;
@end
