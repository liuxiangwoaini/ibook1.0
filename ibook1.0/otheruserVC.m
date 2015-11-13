//
//  otheruserVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "otheruserVC.h"
#import "UIImageView+WebCache.h"
#import "PersonActivityVC.h"
#import "NSObject+LX.h"
@interface otheruserVC ()<UITableViewDataSource,UITableViewDelegate>
- (IBAction)close;
@property (weak, nonatomic) IBOutlet UIImageView *headview;
@property (weak, nonatomic) IBOutlet UITableView *persontable;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (strong ,nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
- (IBAction)ceshi;
@end

@implementation otheruserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect tableframe = self.persontable.frame;
    self.persontable.frame = CGRectMake(tableframe.origin.x, tableframe.origin.y, self.view.frame.size.width, 44*3);
    self.persontable.dataSource = self;
    self.persontable.delegate  =self;
}
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        
        [_datas addObject:@"发起的活动"];
        [_datas addObject:@"报名的活动"];
        [_datas addObject:@"结束的活动"];
        
    }
    return _datas;
}

- (void)setUser:(AVUser *)user
{
    _user = user;

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIView animateWithDuration:0 animations:^{
        self.navigationController.navigationBarHidden = YES;
    }];
    
    self.headview.image = [self circleImage:[UIImage imageNamed:@"avatar_default.png"] withParam:1];
    //    iBookUser *u = [[iBookUser alloc] initwithdict:dict];
    //    NSLog(@"%@---%@", dict[@"nickname"],user);
    NSString *url = [NSString stringWithFormat:@"%@", self.user[@"avatarUrl"]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cacheType  = SDImageCacheTypeDisk;
        if (finished) {
            UIImage *image1 = [self circleImage:image withParam:0];
            self.headview.image = image1;
        }
    }];
    self.nickname.text = self.user[@"nickname"];
    self.place.text = self.user[@"school"];
}
- (IBAction)close {
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    if (!(self.navigationController.childViewControllers.count== 3)) {
         self.navigationController.navigationBarHidden = NO;
    }
    

}

//- (void)sethead
//{
//    AVUser *user = self.user;
//    ;
//
//    
//    //    [self.headview sd_setImageWithURL:[NSURL URLWithString:url]];
//    
//    
//}



-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"xixi12";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =self.datas[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    CGRect frame1 = CGRectMake(0, 0, [NSObject settableviewcellsizewithinchs], 320);
//    cell.bounds = frame1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (indexPath.row) {
//        case 0:
//        {
//            
////            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
//            UIViewController *vc = [[UIViewController alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
//            break;
//        }
//        case 1:
//        {
//            
//            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
//                       [self presentViewController:vc animated:YES completion:nil];
//            break;
//        }
//       
//        
//        default:
//        {
//            PersonActivityVC *vc = [[PersonActivityVC alloc] init];
//                       [self presentViewController:vc animated:YES completion:nil];
//            break;
//        }
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreactivi" object:nil userInfo:@{@"objID":self.user.objectId,@"row":@(indexPath.row)}];
    PersonActivityVC *vc = [[PersonActivityVC alloc] init];
    vc.userobjID =self.user.objectId;
//
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ceshi {
 
}
@end
