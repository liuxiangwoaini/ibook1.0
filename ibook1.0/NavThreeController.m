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
@interface NavThreeController ()

@end

@implementation NavThreeController

- (void)loadView {
    [super loadView];
    NotLoginVC *root = [[NotLoginVC alloc] init];
    [self addChildViewController:root];
    self.navigationBarHidden = YES;
}

@end
