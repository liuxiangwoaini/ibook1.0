//
//  PersonActivityVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-25.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "PersonActivityVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+MJ.h"
#import "PersonAcitiviCell.h"
#import "NSString+LX.h"
@interface PersonActivityVC ()
@property (nonatomic, strong) NSMutableArray *activities;
@end



@implementation PersonActivityVC

- (NSMutableArray *)activities
{
    if (_activities == nil) {
        _activities = [NSMutableArray array];
    }
    return _activities;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setdatas];
    self.navigationItem.title = @"我的活动";
    self.tableView.rowHeight = 80;
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 7, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_left.png"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"ic_left.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:btn];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [self ceshi];
    
    
}

//
//{
//    "remark": "陌陌陌陌摸摸摸",
//    "place": "哈尔滨学院-图书馆",
//    "isUseful": 0,
//    "type": 15006,
//    "title": "哦去",
//    "commentCount": 0,
//    "target": 15009,
//    "applyCount": 0,
//    "owner": {
//        "__type": "Pointer",
//        "className": "_User",
//        "objectId": "55fab8f1ddb2dd0026b2e42c"
//    },
//    "ACL": {
//        "*": {
//            "read": true,
//            "write": true
//        }
//    },
//    "endTime": {
//        "__type": "Date",
//        "iso": "2015-10-04T20:12:09.437Z"
//    },
//    "pubLocation": {
//        "__type": "GeoPoint",
//        "latitude": 45.707239,
//        "longitude": 126.62458
//    },
//    "objectId": "55fd511cddb2af5b91eba75f",
//    "createdAt": "2015-09-19T20:12:12.707Z",
//    "updatedAt": "2015-10-21T18:16:44.943Z"
//}

- (void)ceshi
{
    AVUser *user = [AVUser currentUser];
    AVObject *post = [AVObject objectWithClassName:@"Activities"];
    [post setObject:@"每个 Objective-C " forKey:@"remark"];
    [post setObject:@"每个 Objective-Casd " forKey:@"title"];
    [post setObject:@"哈尔滨学院-图书馆" forKey:@"place"];
    [post setObject:@(15006) forKey:@"type"];
    [post setObject:user forKey:@"owner"];
    
    [post saveInBackground];
}
- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setdatas
{
    AVQuery *query = [AVQuery queryWithClassName:@"Activities"];
    __block NSString *imageurl;
//    [query whereKey:@"owner" equalTo:];
    AVUser *user = [AVUser currentUser];
//    NSLog(@"%@", user.objectId);
   
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
                        // 检索成功

        for (id hehe in objects) {
            AVUser *user1 = hehe[@"owner"];
//            NSLog(@"%@", user1.objectId);
//            NSLog(@"%@", user1.objectId);
            if ([user1.objectId isEqualToString:user.objectId]) {
                [self.activities addObject:hehe];
                
            }
            
            
        }
        [self.tableView reloadData];
        
    
    } else {
                        // 输出错误信息
    NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    }];
    
//    if (!self.activities.count) {
//        [MBProgressHUD showError:@"没有数据"];
//    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"xixi1";
    PersonAcitiviCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonAcitiviCell" owner:nil options:nil] lastObject];
    }
    AVObject *obj = self.activities[indexPath.row];
#warning 这里强转可能会有bug
    cell.title.text  = obj[@"title"];
    cell.place.text = obj[@"place"];
    cell.remark.text = obj[@"remark"];
//    NSLog(@"%@--%@--%@--",obj[@"title"],obj[@"place"],obj[@"remark"] );
    cell.type.text = [NSString activitype:obj[@"type"]];
    return cell;
}



@end
