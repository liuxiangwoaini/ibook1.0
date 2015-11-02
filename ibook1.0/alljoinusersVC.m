//
//  alljoinusersVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "alljoinusersVC.h"
#import "UIImageView+WebCache.h"
#import "alljoinusersCell.h"
#import "otheruserVC.h"
@interface alljoinusersVC ()
@property (nonatomic, strong) NSMutableArray *userids;
@property (nonatomic, strong) NSMutableArray *users;
@end

@implementation alljoinusersVC

- (NSMutableArray *)users
{
    if (_users == nil) {
        _users= [NSMutableArray array];
    }
    return _users;
}

- (NSMutableArray *)userids
{
    if (_userids == nil) {
        _userids = [NSMutableArray array];
    }
    return _userids;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor blueColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 7, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"ic_left.png"] forState:UIControlStateNormal];
    //        [btn setBackgroundImage:[UIImage imageNamed:@"ic_left.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:btn];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    AVQuery *query1 = [AVQuery queryWithClassName:@"Activities"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj1 in objects) {
                if ([obj1.objectId isEqualToString:self.obj.objectId]) {
                    self.userids = obj1[@"joinuserid"];
                }
            }
            
        }
        
    }];
    
    AVQuery *query2 = [AVQuery queryWithClassName:@"_User"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVUser *user1 in objects) {
                for (NSString *userid in self.userids) {
                    if ([userid isEqualToString:user1.objectId]) {
                        [self.users addObject:user1];
                    }
                }
            }
            
        }
        
        [self.tableView reloadData];
        
    }];
    
    
}


- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"user";
    AVUser *user = self.users[indexPath.row];
    alljoinusersCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"alljoinusersCell" owner:nil options:nil] lastObject];
    }
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:user[@"avatarUrl"]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cacheType  = SDImageCacheTypeDisk;
        if (finished) {
            UIImage *image1 = [self circleImage:image withParam:1];
            cell.headimage.image = image1;
        }
        
        
    }];
    cell.user = user;
    cell.username.text = user[@"nickname"];
    
    return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVUser *user = self.users[indexPath.row];
    otheruserVC *other = [[otheruserVC alloc] init];
    other.user = user;
    [self.navigationController pushViewController:other animated:YES];
}

@end
