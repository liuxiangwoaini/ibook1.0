//
//  activitydetailCell.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-1.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "activitydetailCell.h"
#import "UIImageView+WebCache.h"


@interface activitydetailCell()
@property (weak, nonatomic) IBOutlet UIButton *headbtn;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong ,nonatomic) AVUser *commentuser;

@end
@implementation activitydetailCell


- (void)setObj:(AVObject *)obj
{
        _obj= obj;
    self.comment.text = obj[@"content"];
    self.time.text =[[obj[@"createdAt"] description] substringToIndex:10];
    AVUser *user =obj[@"fromUser"];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            for (AVUser *obj1 in objects) {
                //                NSLog(@"%@---%@", obj1.username, user.username);
                if ([obj1.objectId isEqualToString:user.objectId]) {
                    
                    self.commentuser = obj1;
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    
                    [manager downloadImageWithURL:[NSURL URLWithString:obj1[@"avatarUrl"]] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        cacheType  = SDImageCacheTypeDisk;
                        if (finished) {
                            UIImage *image1 = [self circleImage:image withParam:1];
                            [self.headbtn setBackgroundImage:image1 forState:UIControlStateNormal];
                        }
                        
                        
                    }];
                    
//                    self.username1.text = obj1[@"nickname"];
                    
                    
                    
                    
                    
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

//atyObjId = 5630b98a60b20fc9ded85bc3;
//commentType = 15018;
//content = "\U3002\U3002\U3002\U3002\U3002\U5e74\U5ea6\U795e\U66f2";
//fromUser = "<AVUser, _User, 55fab8f1ddb2dd0026b2e42c, localData:{\n    \"__type\" = Pointer;\n}, estimatedData:{\n}, relationData:{\n}>";
//toUserNickname = "";
//toUserObjId = 55fd3bc660b2af39552a1b18;
                

- (IBAction)btnclick {
//    otheruserVC *other = [[otheruserVC alloc] init];
//    other.user = self.commentuser;
    
    [self.delegate clickactivitydetailheadbtnwithuserdata:self.commentuser];
    
}

                


@end
