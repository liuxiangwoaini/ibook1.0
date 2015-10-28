//
//  homeVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "homeVC.h"
#import "UIImage+MJ.h"
#import "commonhead.h"
#import "NSString+LX.h"
#import <AVOSCloud/AVOSCloud.h>
#import "homedataCell.h"
@interface homeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (strong ,nonatomic) UIButton *addbtn;
@property (strong ,nonatomic) UIView *chooseview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *activities;
@end

@implementation homeVC

- (NSMutableArray *)activities
{
    if (_activities == nil) {
        
        AVQuery *query = [AVQuery queryWithClassName:@"Activities"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // 检索成功
                _activities = [NSMutableArray arrayWithArray:objects];
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
                
                
                
                
            } else {
                // 输出错误信息
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }

    return _activities;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAddbtn1];
    [self setchoosebtns];
    NSInteger num = self.activities.count;
    self.tableview.dataSource =self;
    self.tableview.delegate = self;

    self.tableview.rowHeight = 80;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    AVUser *user = [AVUser currentUser];
    if (user) {
        self.addbtn.hidden = NO;
        
    }
}

- (void)setchoosebtns
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(250, 45, 60, 200)];
    view.backgroundColor = [UIColor blueColor];
    
    NSArray *temp = @[@"陪看书",@"去自习",@"找书友",@"换本书",@"求教材",@"求补课"];
//    NSArray *num = @[@(15001),@(15002),@(15003),@(15004),@(15005),@(15006),];
    for (int i = 0; i < 6; i ++) {
        NSString *title = temp[i];
        UIButton *btn = [self addbtnwithtitle:title];
        btn.frame = CGRectMake(0, i * 33.3, 60, 25);
        btn.tag = i;
        [btn addTarget:self action:@selector(pubactivity:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    view.hidden = YES;
    self.chooseview = view;
    [self.view addSubview:view];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", self.activities.count);
    return self.activities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"home12";
    homedataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"homedataCell" owner:nil options:nil] lastObject];
    }
    AVObject *obj = self.activities[indexPath.row];
#warning 这里强转可能会有bug
//    cell.title.text  = obj[@"title"];
//    cell.place.text = obj[@"place"];
//    cell.remark.text = obj[@"remark"];
//    //    NSLog(@"%@--%@--%@--",obj[@"title"],obj[@"place"],obj[@"remark"] );
//    cell.type.text = [NSString activitype:obj[@"type"]];
    cell.dict =(NSDictionary *) obj;
    return cell;
}

- (void)pubactivity:(UIButton *)btn
{
    NSArray *num = @[@"15001",@"15002",@"15003",@"15004",@"15005",@"15006"];
    NSInteger he = [num[btn.tag] intValue];
    NSLog(@"%@", [NSString activitype:he]);
}
- (UIButton *)addbtnwithtitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 60, 25);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}



- (void)setAddbtn1
{

//    CGFloat scrollW = self.midScrollView.frame.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(250, 250, 60, 60);
    //    btn.backgroundColor = [UIColor redColor];
    UIImage *backimage = [UIImage circleImageWithName:@"avatar_default_add.png" borderWidth:1 borderColor:IBColor(238, 238, 238)];
    
    [btn setImage:backimage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addbtnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    self.addbtn = btn;
    [self.view addSubview:btn];
    
}
- (void)addbtnclick
{
    self.chooseview.hidden = !self.chooseview.hidden;
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//"remark": "图兔兔吐了",
//"place": "哈尔滨理工大学南校区图书馆",
//"isUseful": 0,
//"type": 15006,
//"title": "今天真是的",
//"commentCount": 1,
//"target": 15009,
//"applyCount": 0,
//"owner": {
//    "__type": "Pointer",
//    "className": "_User",
//    "objectId": "55fab8f1ddb2dd0026b2e42c"
//},
//"ACL": {
//    "*": {
//        "read": true,
//        "write": true
//    }
//},
//"endTime": {
//    "__type": "Date",
//    "iso": "2015-09-24T21:09:57.919Z"
//},
//"pubLocation": {
//    "__type": "GeoPoint",
//    "latitude": 45.70801,
//    "longitude": 126.627673
//},
//"objectId": "55fabba760b2849751b8905c",
//"createdAt": "2015-09-17T21:09:59.537Z",
//"updatedAt": "2015-10-21T18:16:52.339Z"

@end
