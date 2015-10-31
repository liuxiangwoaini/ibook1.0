//
//  NavTwoController.m
//  SlideTest
//
//  Created by 胡大函 on 14/10/10.
//  Copyright (c) 2014年 HuDahan_payMoreGainMore. All rights reserved.
//

#import "NavTwoController.h"
#import "homeTableVC.h"
@interface NavTwoController ()

@end

@implementation NavTwoController
- (void)viewDidLoad
{
    [super viewDidLoad];
//    homeTableVC *home = [[homeTableVC alloc] init];
//    [self addChildViewController:home];
//    self.navigationBarHidden = YES;
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc] initWithTitle:@"hehe" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_location.png"] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItems =@[item1, item2];
//    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSLog(@"%@", self.childViewControllers);
}
@end
