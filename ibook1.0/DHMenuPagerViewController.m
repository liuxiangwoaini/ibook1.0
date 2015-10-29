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
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AVOSCloud/AVOSCloud.h>
#import "WGS84TOGCJ02.h"
#import "homeVC.h"
#define kTopBarHeight 0
#define kMenuViewHeight 30
#import "otheruserVC.h"
#import "activitydetailVC.h"
#import "PersonActivityVC.h"

@interface DHMenuPagerViewController () <MenuViewDelegate, CLLocationManagerDelegate,homeVCdelegate> {
    NSArray *titleArray;
    DHLandscapeMenuScrollView *menuView;
    DHLandscapeTableView *contentView;
    
}
@property (nonatomic ,strong) UIView *navrightview;
@property (nonatomic ,strong) UILabel *navrightlable;
@property (strong, nonatomic) CLLocationManager *manage;
@property (assign ,nonatomic) CLLocation *location;
@property (nonatomic, assign) BOOL getlocation;
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
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if (city.length) {
        lable.text = city;
    }else
    {
        lable.text = @"未定位";
    }
    
    
    lable.textAlignment = NSTextAlignmentRight;
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = [UIColor whiteColor];
    self.navrightlable = lable;
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
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate =self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager requestWhenInUseAuthorization];
    
    [manager requestAlwaysAuthorization];
    [manager startUpdatingLocation];
    self.manage =manager;
    self.getlocation = NO;
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    //    NSLog(@"%@", location);
#warning 地理位置看反编码失败，下面这个方法进不去
#warning 这个方法有时进得去，有时进不去，真是日了狗了
    
//    CLLocation *new ;
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        
    }
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"%@--- %d", error.localizedDescription, error.code);
        }
        if (placemarks > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *city = placemark.addressDictionary[@"City"];
            NSLog(@"%@", city);
            //            NSString *Street = placemark.addressDictionary[@"Street"];
            //            NSString *SubLocality = placemark.addressDictionary[@"SubLocality"];
            //            NSString *fullcity =
//            NSUInteger length = city.length;
//            NSString *fullcity;
//            if (length > 5) {
//                fullcity = [city substringToIndex:2];
//            }else
//            {
//                fullcity = [city substringToIndex:length-1];
//            }
//
//            self.location = location;
//            NSLog(@"%f", location.coordinate.latitude);
            self.navrightlable.text = city;

            AVUser *user = [AVUser currentUser];
            
            if (user) {
                AVGeoPoint *point = [AVGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
                [user setObject:point forKey:@"lastLocation"];
                [user setObject:city forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setValue:city forKey:@"city"];
                [user saveInBackground];
            }
            
            [self.manage stopUpdatingLocation];
        }}];
        
    
    
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//
    if (self.getlocation) {
        return;
    }
    AVUser *user = [AVUser currentUser];
    if (user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVC" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVC1" object:nil];
    }
//    user[@"dasd"];
    if (user[@"lastLocation"]) {
        
        return;
    }
    
    if (user)
    {
        [self.manage startUpdatingLocation];
        self.getlocation = YES;
    }
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
- (void)changedetailactiviVCwithdata:(AVObject *)data
{
    activitydetailVC *vc = [[activitydetailVC alloc] init];
//    vc.tabBarController.tabBar.hidden = YES;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#warning 这里做转场动画....一定要做一定要做。。。。。
- (void)changetouserdata:(AVUser *)user
{
    otheruserVC *other = [[otheruserVC alloc] init];
    other.user = user;
//    NSLog(@"%@",user);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreactivity:) name:@"moreactivi" object:nil];
    [self.navigationController presentViewController:other animated:YES completion:nil];
//    [UIView animateWithDuration:3 animations:^{
//        other.view.transform = CGAffineTransformMakeTranslation(0, -200);
//    } completion:^(BOOL finished) {
//        other.view.transform = CGAffineTransformIdentity;
//    }];
   
}
#warning 这个地方还有问题。。。明天继续
- (void)moreactivity:(NSNotification *)noti
{
    PersonActivityVC *vc = [[PersonActivityVC alloc] init];
    vc.userobjID =noti.userInfo[@"objID"];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];

}


@end
