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
#import "FMDB.h"
#import "activity.h"
#import "DHMenuPagerViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "activitydetailVC.h"
#import "pubactivityVC.h"
#import "NSObject+LX.h"

@interface homeVC ()<UITableViewDataSource, UITableViewDelegate,DHMenuPagerViewDelegate, homedataCelldelegate>
@property (strong ,nonatomic) UIButton *addbtn;
@property (strong ,nonatomic) UIView *chooseview;
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *activitiedatas;

@end

@implementation homeVC
#warning 重写下cell。。。。

- (NSMutableArray *)activitiedatas
{
    if (_activitiedatas == nil) {
        _activitiedatas = [NSMutableArray array];
    }
    
    return _activitiedatas;
}
- (NSMutableArray *)activities
{
    if (_activities == nil) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbpath = [path stringByAppendingPathComponent:@"activitesdata"];
        NSArray *array = [NSArray arrayWithContentsOfFile:dbpath];
        if (array.count > 0) {
            _activities = [NSMutableArray arrayWithArray:array];

            AVQuery *query = [AVQuery queryWithClassName:@"Activities"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // 检索成功
                    self.activitiedatas = [NSMutableArray arrayWithArray:objects];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableview reloadData];
                    });
                    
                }}];
            

            
        }else
        {
            AVQuery *query = [AVQuery queryWithClassName:@"Activities"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // 检索成功
                    _activities = [NSMutableArray arrayWithArray:objects];
                    self.activitiedatas = [NSMutableArray arrayWithArray:objects];
                    
                    NSMutableArray *temp = [NSMutableArray array];
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *dbpath = [path stringByAppendingPathComponent:@"activitesdata"];
//                    NSArray *array = [NSArray arrayWithContentsOfFile:dbpath];
                    
                    
                    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *dict = (NSDictionary *)obj;
//                        NSLog(@"%@", [dict class]);
                        NSString *title = obj[@"title"];
                        NSString *remark = obj[@"remark"];
                        NSString *place = obj[@"place"];
                        NSInteger target = (NSInteger)obj[@"target"];
                        NSInteger type= (NSInteger )obj[@"type"];
                        NSInteger isuseful =(NSInteger)obj[@"isUseful"];
                        NSDictionary *dict1 = @{@"title":title, @"remark":remark, @"place":place,@"target":@(target),@"type":@(type),@"isuseful":@(isuseful)};
                        [temp addObject:dict1];
                    }];
                    
                    [temp writeToFile:dbpath atomically:YES];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableview reloadData];
                    });
                    
//                    NSData
                    
                    
                } else {
                    // 输出错误信息
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        

    }

    return _activities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (iphone6) {
    self.view.frame = [NSObject setVCviewframewithinchs];
        //
        //    CGRect frame1 = CGRectMake(0, 0, 375, self.tableview.frame.size.height);
        //            self.tableview.frame = frame1;
        //            self.tableview.backgroundColor = [UIColor redColor];
//    }
//    NSLog(@"----frame%f", self.view.frame.size.width);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVC) name:@"changeVC" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVC1) name:@"changeVC1" object:nil];
    
    NSInteger num = self.activities.count;
    self.tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-155)];
    
    self.tableview.dataSource =self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    self.tableview.rowHeight = 320;
    self.tableview.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tableview];
//    NSLog(@"aaaaa%f", self.view.frame.size.width);
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self getdatafromnet];
        
        [self.tableview.header endRefreshing];
        
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"放开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新 ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:20];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:20];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    self.tableview.header = header;
//    self.tableview.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [MBProgressHUD showError:@"没有更多数据了。。。。"];
//    }];
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [MBProgressHUD showError:@"没有更多数据了。。。。"];
        [self.tableview.footer endRefreshing];
//        self.tableview.footer.hidden = YES;
    }];
    
//    BOOL net = [NSObject connectwithnum];
    self.navigationController.navigationBarHidden = YES;
    
}



- (void)getdatafromnet
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [path stringByAppendingPathComponent:@"activitesdata"];
    NSFileManager *manage = [NSFileManager defaultManager];
//    NSLog(@"%@", [NSArray arrayWithContentsOfFile:dbpath]);
    NSError *error;
    if([manage removeItemAtPath:dbpath error:nil])
    {
        
        self.activities = nil;
        if ([NSArray arrayWithContentsOfFile:dbpath]) {
            [MBProgressHUD showError:@"刷新失败"];
        }else
        {
            NSInteger num = self.activities.count;
            [MBProgressHUD showSuccess:@"刷新成功"];
        }
    }else
    {
        [MBProgressHUD showError:@"删除失败,刷新失败"];
    };
//    NSLog(@"%@", [NSArray arrayWithContentsOfFile:dbpath]);
    
//    if ([NSArray arrayWithContentsOfFile:dbpath]) {
//        [MBProgressHUD showError:@"刷新失败"];
//    }else
//    {
//    [MBProgressHUD showSuccess:@"刷新成功"];
//    }
    
    
}



- (void)changeVC
{
    self.addbtn.hidden = NO;
}
- (void)changeVC1
{
    self.addbtn.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setAddbtn1];
    [self setchoosebtns];

//    if (iphone6) {
////        375x667
//        self.view.bounds = CGRectMake(0, 0, 375, 667);
//        
//    }
    AVUser *user = [AVUser currentUser];
    if (user) {
        self.addbtn.hidden = NO;
        
    }
}

- (void)setchoosebtns
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(self.addbtn.frame.origin.x, self.addbtn.frame.origin.y - 210, 60, 200)];
    view.backgroundColor = [UIColor blueColor];
    
    
    NSArray *temp = @[@"陪看书",@"去自习",@"找书友",@"换本书",@"求教材",@"求补课"];
//    NSArray *num = @[@(15001),@(15002),@(15003),@(15004),@(15005),@(15006),];
    for (int i = 0; i < 6; i ++) {
        NSString *title = temp[i];
        UIButton *btn = [self addbtnwithtitle:title];
        btn.frame = CGRectMake(0, i * 33.3+5, 60, 25);
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
    cell.delegate =self;
//    NSLog(@"%d----", self.activitiedatas.count);
    if (self.activitiedatas.count) {
        cell.obj = self.activitiedatas[indexPath.row];
    }
    
//
        CGRect frame1 = CGRectMake(0, 0, [NSObject settableviewcellsizewithinchs], 320);
        cell.bounds = frame1;
////
    
  
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:nil];lue
//    cell.textLabel.text = @"dasda";
//    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}
#warning 这里跳转到发布活动页面
- (void)pubactivity:(UIButton *)btn
{
    NSArray *num = @[@"15001",@"15002",@"15003",@"15004",@"15005",@"15006"];
    NSInteger he = [num[btn.tag] intValue];
//    NSLog(@"%@", [NSString activitype:he]);
//    pubactivityVC *pub = [[pubactivityVC alloc] init];
//    pub.headlabel.text =[NSString activitype:he];
//    [self.navigationController presentViewController:pub
//                                            animated:YES completion:nil];
    self.chooseview.hidden = YES;
    [self.delegate pubactivityVCwithtitle:[NSString activitype:he]];
    
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
    btn.frame = CGRectMake(self.view.frame.size.width*0.77, self.view.frame.size.height*0.59, 60, 60);
    //    btn.backgroundColor = [UIColor redColor];
    UIImage *backimage = [UIImage circleImageWithName:@"avatar_default_add.png" borderWidth:1 borderColor:IBColor(238, 238, 238)];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn setImage:backimage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addbtnclick) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    self.addbtn = btn;
    [self.view addSubview:btn];
    
}
- (void)addbtnclick
{
    
    self.chooseview.hidden = !self.chooseview.hidden;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [path stringByAppendingPathComponent:@"activitesdata"];
    NSArray *array = [NSArray arrayWithContentsOfFile:dbpath];
    NSLog(@"%@", array);
    
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

- (void)getfromdb
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [path stringByAppendingPathComponent:@"activitesdata.db"];
    NSFileManager *manage = [[NSFileManager alloc] init];
    if([manage fileExistsAtPath:dbpath])
    {
        FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
        if ([db open]) {
            NSLog(@"get--db成功");
        }
        
        FMResultSet *result = [db executeQuery:@"SELECT City, Weather  FROM CityWeather"];
        while ([result next]) {
            NSData *data = [result dataForColumn:@"Weather"];
//            [self.datas addObject:data];
        }
    }
    else
    {
        return;
    }
    
}


- (void)setupdatabaseWithCithname:(NSString *)name andData:(NSData *)data
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [path stringByAppendingPathComponent:@"cityweather.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if ([db open]) {
        NSLog(@"db 打开成功");
        [db executeUpdate:@"CREATE TABLE if not exists CityWeather (City text, Weather blob)"];
        [db executeUpdate:@"INSERT INTO  CityWeather(City, Weather ) VALUES (?,?)",name, data];
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id data = self.activitiedatas[indexPath.row];
//    NSLog(@"%@", self.activitiedatas);
    if (self.activitiedatas.count == 0) {
        [MBProgressHUD showError:@"网络不好请稍等"];
        return;
    }
//    activitydetailVC *vc = [[activitydetailVC alloc] init];
    //    vc.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.delegate changedetailactiviVCwithdata:self.activitiedatas[indexPath.row] anddict:self.activities[indexPath.row]];
    
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

- (void)clickheadbtnwithuserdata:(AVUser *)user
{
    if (!user) {
        return;
    }
    [self.delegate changetouserdata:user];
}

@end
