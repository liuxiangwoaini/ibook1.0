//
//  DHMenuPagerViewController.m
//  DHMenuViewPager
//
//  Created by 胡大函 on 14/9/30.
//  Copyright (c) 2014年 HuDahan_payMoreGainMore. All rights reserved.
//

#import "DHMenuPagerViewController.h"
#import "DHLandscapeTableView.h"
#import "DHLandscapeMenuScrollView.h"
#define kTopBarHeight 0
#define kMenuViewHeight 30
@interface DHMenuPagerViewController () <MenuViewDelegate> {
    NSArray *titleArray;
    DHLandscapeMenuScrollView *menuView;
    DHLandscapeTableView *contentView;
    
}
@property (nonatomic ,strong) UIView *navrightview;
@property (nonatomic ,strong) UILabel *navrightlable;
@end

@implementation DHMenuPagerViewController

- (id)initWithViewControllers:(NSArray *)controllers {
    return [self initWithViewControllers:controllers titles:nil];
}

- (id)initWithViewControllers:(NSArray *)controllers titles:(NSArray *)titles {
    return [self initWithViewControllers:controllers titles:titles menuBackgroundColor:nil titleColor:nil titleColorHighlighted:nil];
}

- (id)initWithViewControllers:(NSArray *)controllers titles:(NSArray *)titles menuBackgroundColor:(UIColor *)backColor titleColor:(UIColor *)normalColor titleColorHighlighted:(UIColor *)highlightedColor {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (titles) {
            titleArray = titles;
            menuView = [[DHLandscapeMenuScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, self.view.frame.size.width, kMenuViewHeight) Titles:titles shouldShowIndicatorView:NO menuBackgroundColor:backColor titleColor:normalColor titleColorHighlighted:highlightedColor];
            menuView.clickDelegate = self;
            [self.view addSubview:menuView];
            contentView = [[DHLandscapeTableView alloc] initWithFrame:CGRectMake(0, kTopBarHeight + kMenuViewHeight, self.view.frame.size.width, self.view.frame.size.height - kTopBarHeight - kMenuViewHeight) viewArray:controllers];
            [self.view addSubview:contentView];
        } else {
            contentView = [[DHLandscapeTableView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, self.view.frame.size.width, self.view.frame.size.height - kTopBarHeight) viewArray:controllers];
            [self.view addSubview:contentView];
        }
        contentView.swipDelegate = self;
    }
//    self.navigationController.navigationBar.hidden = YES;
    self.navrightview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    lable.text = @"哈尔滨";
    lable.textAlignment = NSTextAlignmentRight;
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 5, 40, 34);
    [btn addTarget:self action:@selector(chooselocation) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_location.png"] forState:UIControlStateNormal];
    [self.navrightview addSubview:btn];
    [self.navrightview addSubview:lable];
//    self.navrightview.backgroundColor = [UIColor greenColor];
    UIBarButtonItem *item1 =[[UIBarButtonItem alloc] initWithTitle:@"hehe" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *item2 =[[UIBarButtonItem alloc] initWithCustomView:self.navrightview ];
    self.navigationItem.rightBarButtonItems =@[item2];
    return self;
}

- (void)chooselocation
{
    
}

- (void)menuSelectedBtnIndex:(NSUInteger)tag {
    [contentView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)contentViewChangedIndex:(NSUInteger)tag {
    if (_delegate) {
        [_delegate changedTitle:titleArray[tag]];
    }
    [menuView selectBtnWithTag:tag];
}

- (void)contentViewChangedAtIndex:(NSUInteger)tag offset:(CGPoint)offset {
    [menuView changeIndicatorViewWithPage:tag offset:offset.y];
}

@end
