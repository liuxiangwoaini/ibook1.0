//
//  homedataCell.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "homedataCell.h"
#import "NSString+LX.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+WebCache.h"
@interface homedataCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *target;
@property (weak, nonatomic) IBOutlet UIButton *headbtn;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userpubtime;
@property (weak, nonatomic) IBOutlet UILabel *joinnum;

@property (weak, nonatomic) IBOutlet UIImageView *bigimage;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@property (strong, nonatomic) AVUser *userdata;
@end
@implementation homedataCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.title.text = dict[@"title"];
    self.remark.text = dict[@"remark"];
    self.place.text = dict[@"place"];
    self.type.text = [NSString activitype:[dict[@"type"] intValue]];
    self.target.text = [NSString activitarget:[dict[@"target"] intValue]];
    NSArray *temp = @[@"card_img",@"img_change_book",@"img_find_friend", @"img_read",@"img_request_book",@"img_request_lesson",@"img_study"];
    int num = arc4random()% temp.count;
    NSString *path = [NSString stringWithFormat:@"%@.jpg", temp[num]];
    self.bigimage.image = [UIImage imageNamed:path];
//    UIImage *image = [self circleImage:[UIImage imageNamed:@"avatar_default.png"] withParam:1];
//    self.headbtn.imageView.image = image;
    [self.headbtn addTarget:self action:@selector(persondetail) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)persondetail
{
    if (self.userdata) {
        [self.delegate clickheadbtnwithuserdata:self.userdata];
    }
}
//-(void)setFrame:(CGRect)frame {
//    CGFloat y = frame.origin.y +10;
//    CGRect rect = CGRectMake(frame.origin.x,y , frame.size.width, frame.size.height);
//    self.contentView.frame = rect;
//    [super setFrame:frame];
//}

- (void)setObj:(AVObject *)obj
{
    _obj = obj;
    NSDate *date = obj[@"endTime"];
    
    self.userpubtime.text =[[date description] substringToIndex:10];
    self.comment.text = [NSString stringWithFormat:@"评论%@条", (NSNumber *)obj[@"commentCount"]];
    
    self.joinnum.text = [NSString stringWithFormat:@"报名%@人", (NSNumber *)obj[@"applyCount"]];
    AVUser *user = obj[@"owner"];
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
                    
                    self.username.text = obj1[@"nickname"];
                    

                    
                    
                    
                }
            }
            
            
        }}];
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
@end
