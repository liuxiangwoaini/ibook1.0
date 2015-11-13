//
//  activitydetailVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "activitydetailVC.h"
#import "NSString+LX.h"
#import "UIImageView+WebCache.h"
#import "otheruserVC.h"
#import "activitydetailCell.h"
#import "MBProgressHUD+MJ.h"
#import "addcommentVC.h"
#import "NSNumber+LX.h"
#import "alljoinusersVC.h"
@interface activitydetailVC ()<UITableViewDataSource, UITableViewDelegate,activitydetailCelldelegate>
- (IBAction)close;
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UILabel *remark;
//@property (weak, nonatomic) IBOutlet UILabel *place;
//@property (weak, nonatomic) IBOutlet UILabel *type;
//@property (weak, nonatomic) IBOutlet UILabel *target;
//
//@property (weak, nonatomic) IBOutlet UILabel *username;
//@property (weak, nonatomic) IBOutlet UILabel *userpubtime;
//@property (weak, nonatomic) IBOutlet UILabel *joinnum;
//
//@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *headbtn;
@property (weak, nonatomic) IBOutlet UIImageView *bigimage;

@property (weak, nonatomic) IBOutlet UIButton *joinbtn;

- (IBAction)addcomment:(id)sender;
@property (strong, nonatomic) AVUser *userdata;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *place1;
@property (weak, nonatomic) IBOutlet UILabel *remark1;
@property (weak, nonatomic) IBOutlet UILabel *type1;
@property (weak, nonatomic) IBOutlet UILabel *target1;
@property (weak, nonatomic) IBOutlet UILabel *username1;
@property (weak, nonatomic) IBOutlet UILabel *userpubtime1;
@property (weak, nonatomic) IBOutlet UILabel *commen1;
- (IBAction)join;
@property (weak, nonatomic) IBOutlet UILabel *joinnum1;
#warning 写到这里。。。
@property (strong ,nonatomic) UITableView *commenttable;
@property (strong, nonatomic) NSMutableArray *commentdatas;
@end
#warning 明天继续。。。
@implementation activitydetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headbtn.userInteractionEnabled = YES;
    
    
    self.commenttable = [[UITableView alloc] initWithFrame:CGRectMake(0, 340, 320, 60*self.commentdatas.count)];
    self.commenttable.rowHeight = 60;
    [self.scrollview addSubview:self.commenttable];
    self.commenttable.delegate = self;
    self.commenttable.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendcommentsucess) name:@"sendcomment" object:nil];
    [self setdata];
    NSMutableArray *array = self.obj[@"joinuserid"];
    AVUser *user =[AVUser currentUser];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:user.objectId]) {
            self.joinbtn.tag =1;
            [self.joinbtn setTitle:@"查看全部报名的人" forState:UIControlStateNormal];
        }
    }];
    
//    self.commenttableview.hidden = YES;
//    
}
- (NSMutableArray *)commentdatas
{
    if (_commentdatas == nil) {
        _commentdatas = [NSMutableArray array];
    }
    return _commentdatas;
}
- (void)setdata
{
    self.title1.text =self.dict[@"title"];
    self.remark1.text = self.dict[@"remark"];
    self.place1.text = self.dict[@"place"];
    self.type1.text = [NSString activitype:[self.dict[@"type"] intValue]];
    self.target1.text = [NSString activitarget:[self.dict[@"target"] intValue]];
    NSArray *temp = @[@"card_img",@"img_change_book",@"img_find_friend", @"img_read",@"img_request_book",@"img_request_lesson",@"img_study"];
    int num = arc4random()% temp.count;
    NSString *path = [NSString stringWithFormat:@"%@.jpg", temp[num]];
    self.bigimage.image = [UIImage imageNamed:path];
    //    UIImage *image = [self circleImage:[UIImage imageNamed:@"avatar_default.png"] withParam:1];
    //    self.headbtn.imageView.image = image;
    [self.headbtn addTarget:self action:@selector(persondetail) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *date = self.obj[@"endTime"];
    
    self.userpubtime1.text =[[date description] substringToIndex:10];
    self.commen1.text = [NSString stringWithFormat:@"评论%@条", (NSNumber *)self.obj[@"commentCount"]];
    
    self.joinnum1.text = [NSString stringWithFormat:@"报名%@人", (NSNumber *)self.obj[@"applyCount"]];
    AVUser *user = self.obj[@"owner"];
    //    NSLog(@"%@", user.objectId);
    //    NSLog(@"%@-----", (NSNumber *)obj[@"commentCount"]);
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            for (AVUser *obj1 in objects) {
                //                NSLog(@"%@---%@", obj1.username, user.username);
                if ([obj1.objectId isEqualToString:user.objectId]) {
                    self.userdata = obj1;
                    
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    
                    [manager downloadImageWithURL:[NSURL URLWithString:obj1[@"avatarUrl"]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        cacheType  = SDImageCacheTypeDisk;
                        if (finished) {
                            UIImage *image1 = [self circleImage:image withParam:1];
                            [self.headbtn setBackgroundImage:image1 forState:UIControlStateNormal];
                        }
                        
                        
                    }];
                    
                    self.username1.text = obj1[@"nickname"];
                    
                    
                    
                    
                    
                }
            }
            
            
        }}];
    if (self.obj[@"commentCount"]) {
        [self setcomment];
    }

}
- (void)setcomment
{
    

    self.commentdatas= nil;
//    NSLog(@"----%@", self.commentdatas);

    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj in objects) {
                if ([obj[@"atyObjId"] isEqualToString:self.obj.objectId]) {
                    
//                    if (!self.commentdatas.count) {
                        [self.commentdatas addObject:obj];
//                    }else
//                    {
//                        for (AVObject *obj2 in self.commentdatas) {
//                            if (!(obj2 == obj) ) {
//                                [self.commentdatas addObject:obj];
//                            }
//                        }
//                    }
                    
                    
 
                }
            }
        }
        NSLog(@"----%f", self.view.frame.size.height);
        self.commenttable.frame = CGRectMake(0, self.view.frame.size.height*0.8, self.view.frame.size.width, 60*self.commentdatas.count);
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.commentdatas.count * 60);
        [self.commenttable reloadData];
        
//        [self.commenttable reloadData];

    }];
    

//    self.commenttableview.hidden = NO;
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commentdatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"home11";
    activitydetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"activitydetailCell" owner:nil options:nil] lastObject];
    }
    AVObject *obj = self.commentdatas[indexPath.row];
#warning 这里强转可能会有bug
    //    cell.title.text  = obj[@"title"];
    //    cell.place.text = obj[@"place"];
    //    cell.remark.text = obj[@"remark"];
    //    //    NSLog(@"%@--%@--%@--",obj[@"title"],obj[@"place"],obj[@"remark"] );
    //    cell.type.text = [NSString activitype:obj[@"type"]];

//    cell.delegate =self;
    //    NSLog(@"%d----", self.activitiedatas.count);
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = @"dasd";
    cell.obj = obj;
    cell.delegate =self;
    return cell;
}

#warning 评论数没有更新。。。
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!self.navigationController.navigationBarHidden) {
       
            self.navigationController.navigationBarHidden = YES;
       
    }
//    [self setcomment];
 
    

    


}
 -(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (self.navigationController.childViewControllers.count == 1) {
        self.navigationController.navigationBarHidden = NO;
    }
    
   
   
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
}


- (IBAction)close {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)setDict:(NSDictionary *)dict
//{
//    _dict = dict;
//
//    
//    
//}

- (void)persondetail
{
    if (self.userdata) {
        otheruserVC *other = [[otheruserVC alloc] init];
        other.user = self.userdata;
        
        //    NSLog(@"%@",user);
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreactivity:) name:@"moreactivi" object:nil];
        [self.navigationController pushViewController:other animated:YES];
    }
}
//-(void)setFrame:(CGRect)frame {
//    CGFloat y = frame.origin.y +10;
//    CGRect rect = CGRectMake(frame.origin.x,y , frame.size.width, frame.size.height);
//    self.contentView.frame = rect;
//    [super setFrame:frame];
//}

//- (void)setObj:(AVObject *)obj
//{
//}

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
- (void)clickactivitydetailheadbtnwithuserdata:(AVUser *)user
{
    otheruserVC *other = [[otheruserVC alloc] init];
    other.user = user;
    
    //    NSLog(@"%@",user);
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreactivity:) name:@"moreactivi" object:nil];
    [self.navigationController pushViewController:other animated:YES];
}

- (IBAction)addcomment:(id)sender {
    AVUser *user =[AVUser currentUser];
    if (!user) {
        [MBProgressHUD showError:@"没有登陆"];
        return;
    }
    addcommentVC *add = [[addcommentVC alloc] init];
    add.fromuser = user;
    add.touser = self.obj[@"owner"];
    add.activiobj = self.obj;
    [self.navigationController pushViewController:add animated:YES];
    
    
}
- (void)sendcommentsucess
{
    self.commentdatas = nil;
    self.commen1.text = nil;
    self.joinnum1.text = nil;
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj in objects) {
                if ([obj[@"atyObjId"] isEqualToString:self.obj.objectId]) {
                    
                  
                    [self.commentdatas addObject:obj];
                    
                    
                    
                    
                }
            }
        }
        //        NSLog(@"----%@", self.commentdatas);
        self.commenttable.frame = CGRectMake(0, 340, 320, 60*self.commentdatas.count);
        [self.commenttable reloadData];
        self.scrollview.contentSize = CGSizeMake(320, 360 + self.commentdatas.count * 60);
        
        
       
        
    }];
    
    
    AVQuery *query1 = [AVQuery queryWithClassName:@"Activities"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *obj1 in objects) {
                if ([obj1.objectId isEqualToString:self.obj.objectId]) {
                    self.commen1.text = [NSString stringWithFormat:@"评论%@条", (NSNumber *)obj1[@"commentCount"]];
                    
                    self.joinnum1.text = [NSString stringWithFormat:@"报名%@人", (NSNumber *)obj1[@"applyCount"]];
                }
            }
            
        }
        
    }];
}
- (IBAction)join {
    if (self.joinbtn.tag == 0) {
        AVUser *user =[AVUser currentUser];
        AVUser *user1 =self.obj[@"owner"];
        if (!user) {
            [MBProgressHUD showError:@"没有登陆"];
            return;
        }else if ([user.objectId isEqualToString:user1.objectId])
        {
            [MBProgressHUD showError:@"自己的活动，已经报名..."];
            return;
        }
        
        NSNumber *newcomment = [NSNumber add:self.obj[@"applyCount"] and:[NSNumber numberWithInt:1]];
        
        NSMutableArray *array = self.obj[@"joinuserid"];
        [array addObject:user.objectId];
        [self.obj setObject:array forKey:@"joinuserid"];
        [self.obj setObject:newcomment forKey:@"commentCount"];
        
        [self.obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"报名成功"];
                self.joinnum1.text = [NSString stringWithFormat:@"报名%@人",newcomment];
                self.joinbtn.tag = 1;
                [self.joinbtn setTitle:@"查看全部报名的人" forState:UIControlStateNormal];
                
            }else
            {
                [MBProgressHUD showError:@"报名失败"];
            }
        }];
    }else
    {
        alljoinusersVC *all = [[alljoinusersVC alloc] init];
        all.obj = self.obj;
        [self.navigationController pushViewController:all animated:YES];
    }

    
    
}
@end
