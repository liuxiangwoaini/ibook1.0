//
//  PersonDataVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-25.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "PersonDataVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
@interface PersonDataVC ()<UIImagePickerControllerDelegate>
- (IBAction)back;
@property (weak, nonatomic) IBOutlet UIImageView *headview;
@property (copy ,nonatomic) NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;
- (IBAction)tianjiatouxiang;
@end

@implementation PersonDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sethead];
    self.progressview.hidden = YES;
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sethead
{
    AVUser *user = [AVUser currentUser];
    ;
    
    //    iBookUser *u = [[iBookUser alloc] initwithdict:dict];
    //    NSLog(@"%@---%@", dict[@"nickname"],user);
    NSString *url = [NSString stringWithFormat:@"%@", user[@"avatarUrl"]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cacheType  = SDImageCacheTypeDisk;
        if (finished) {
            UIImage *image1 = [self circleImage:image withParam:1];
            self.headview.image = image1;
        }
    }];
    
    
    //    [self.headview sd_setImageWithURL:[NSURL URLWithString:url]];
    
    
}
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
- (IBAction)tianjiatouxiang {
    
    
    


    [self.progressview setProgress:0];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    self.progressview.hidden = NO;
    
    
    //当选择一张图片后进入这里
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.progressview.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    
    AVUser *user = [AVUser currentUser];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    ;
    NSString *full = [NSString stringWithFormat:@"%@.jpg", user.username];
    NSString *full1 = [NSString stringWithFormat:@"%@.png", user.username];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        NSLog(@"%@",image);
        
        self.headview.image = [self circleImage:image withParam:1];
        NSData *data;
#warning 不知道返回的图片的扩展名。。。。。搜也搜不到
        if (UIImagePNGRepresentation(image))
        {
            
            data = UIImageJPEGRepresentation(image, 1.0);
            AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.jpg", user.username] data:data];
            
            
            
            
            
            
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
            } progressBlock:^(NSInteger percentDone) {
                [self.progressview setProgress:percentDone animated:YES];
                if (percentDone == 100) {
                    self.progressview.hidden = YES;
                    [MBProgressHUD showSuccess:@"图片上传成功"];
                    [user setObject:file.url forKey:@"avatarUrl"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            NSLog(@"保存chengg");
                            
                        }else
                        {
                            NSLog(@"保存失败");
                        }
                    }];
                }
            }];

            
//            AVQuery *query = [AVQuery queryWithClassName:@"_File"];
//            __block NSString *imageurl;
//            [query whereKey:@"name" equalTo:full];
//            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    // 检索成功
//                    NSDictionary *dict = [objects lastObject];
//                    imageurl = dict[@"localData"][@"url"];
//                    self.imageUrl = imageurl;
//                    
//                } else {
//                    // 输出错误信息
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];

            
            
        }
        else
        {
            
            data = UIImagePNGRepresentation(image);
            AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png", user.username] data:data];
            
            
            
            
            
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
            } progressBlock:^(NSInteger percentDone) {
                [self.progressview setProgress:percentDone animated:YES];
                if (percentDone == 100) {
                    self.progressview.hidden = YES;
                    
                    [MBProgressHUD showSuccess:@"图片上传成功"];
                    [user setObject:file.url forKey:@"avatarUrl"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded){
                            NSLog(@"保存chengg");
                            
                        }else
                        {
                            NSLog(@"保存失败");
                        }
                    }];
                }
            }];
            

            
            
            
        }
        
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    AVUser *user = [AVUser currentUser];
//    NSString *full = [NSString stringWithFormat:@"%@.jpg", user.username];
//    AVQuery *query = [AVQuery queryWithClassName:@"_File"];
//    __block NSString *imageurl;
//    [query whereKey:@"name" equalTo:full];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // 检索成功
//            NSDictionary *dict = [objects firstObject];
//            imageurl = dict[@"localData"][@"url"];
//            self.imageUrl = imageurl;
//            NSLog(@"%@", self.imageUrl);
//            
//            
//        } else {
//            // 输出错误信息
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//    
//    
//    if (self.imageUrl.length) {
////        NSLog(@"%@", self.imageUrl);
//        [user setObject:self.imageUrl forKey:@"avatarUrl"];
//        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded){
//                NSLog(@"保存chengg");
//                
//            }else
//            {
//                NSLog(@"保存失败");
//            }
//        }];
//
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

    
}



@end
