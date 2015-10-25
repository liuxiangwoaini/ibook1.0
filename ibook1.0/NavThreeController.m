//
//  NavThreeController.m
//  SlideTest
//
//  Created by 胡大函 on 14/10/10.
//  Copyright (c) 2014年 HuDahan_payMoreGainMore. All rights reserved.
//

#import "NavThreeController.h"
#import "NotLoginVC.h"
#import "HaveLoginVC.h"
#import <AVOSCloud/AVOSCloud.h>
@interface NavThreeController ()

@end

@implementation NavThreeController

- (void)loadView {
    [super loadView];
    AVUser *user = [AVUser currentUser];
    if (user) {
        HaveLoginVC *root  = [[HaveLoginVC alloc] init];
        NotLoginVC *root1 = [[NotLoginVC alloc] init];
        [self addChildViewController:root1];
        [self addChildViewController:root];
    }else
    {
        NotLoginVC *root = [[NotLoginVC alloc] init];
        [self addChildViewController:root];
    }
    self.navigationBarHidden = YES;
}

@end
