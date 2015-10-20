//
//  registeredVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "registeredVC.h"
#import "commonhead.h"
#import "registerView1.h"
#import "registerView2.h"
#import "registerView3.h"
#import "UIImage+MJ.h"
@interface registeredVC ()<UIScrollViewDelegate, registerView1Delagate,registerView2Delagate,UIImagePickerControllerDelegate, registerView3Delagate>
/**
 *  取消注册，关闭控制器
 */
- (IBAction)close;
/**
 *  中间的scrollview
 */
@property (weak, nonatomic) IBOutlet UIScrollView *midScrollView;

/**
 *  底部的btn
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

/**
 *  记录滚动位置的index
 */

@property (nonatomic, strong) UIView *headpickview;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIDatePicker *birthdaypicker;
@property (nonatomic, strong) UIView *birthdaypicktoolbar;
@property (nonatomic, strong) NSDate *birthdaypdate;


/**
 *  底部btn的点击
 */

- (IBAction)bottomBtnclick;

@end

@implementation registeredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupscrollview];
    self.index = 1;
    self.birthdaypdate = [NSDate date];
    
    [self setAddheadimage];

    
    
    
}

- (void)setAddheadimage
{
    CGFloat scrollW = self.midScrollView.frame.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(scrollW/2 - 40, 30, 80, 80);
//    btn.backgroundColor = [UIColor redColor];
    UIImage *backimage = [UIImage circleImageWithName:@"avatar_default_add.png" borderWidth:1 borderColor:IBColor(238, 238, 238)];
    
    [btn setImage:backimage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addheadimage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

/**
 *  初始化scrollview
 */
- (void)setupscrollview
{
    CGFloat width =self.view.frame.size.width;
    self.midScrollView.contentSize = CGSizeMake(width*3, 260);
    self.midScrollView.pagingEnabled =  YES;
    self.midScrollView.showsHorizontalScrollIndicator = NO;
    self.midScrollView.delegate = self;
    [self addchildviews];
    
    
}
#warning 写到这里，明天继续
- (void)addheadimage
{
    self.headpickview = [[UIView alloc] initWithFrame:CGRectMake(80, 140, 160, 120)];
    self.headpickview.backgroundColor = [UIColor whiteColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(20, 60, 40, 30);
//    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"相机" forState:UIControlStateNormal];
    [btn1 setTitle:@"相机" forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 addTarget:self action:@selector(choosephoto:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1;
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 60, 40, 30);
    [btn2 setTitle:@"相册" forState:UIControlStateNormal];
    [btn2 setTitle:@"相册" forState:UIControlStateHighlighted];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn2 addTarget:self action:@selector(choosephoto:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 2;
//    btn2.backgroundColor = [UIColor blackColor];
    [self.headpickview addSubview:btn1];
    [self.headpickview addSubview:btn2];
    [self.view addSubview:self.headpickview];
}



- (void)choosephoto:(UIButton *)btn
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (btn.tag == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    
    
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.headpickview.hidden = YES;
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    
    self.headpickview.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    ;
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        NSLog(@"%@",image);
        
//        self.tempimage.image = image;
        NSData *data;
#warning 不知道返回的图片的扩展名。。。。。搜也搜不到
//        if (UIImagePNGRepresentation(image))
//        {
//            AVUser *user = [AVUser currentUser];
//            data = UIImageJPEGRepresentation(image, 1.0);
//            AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.jpg", user.username] data:data];
//            
//            [user setObject:file forKey:@"touxiang"];
//            
//            [user setObject:@"liuxiang" forKey:@"haoleng"];
//            
//            
//            
//            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                
//            } progressBlock:^(NSInteger percentDone) {
//                [self.progressview setProgress:percentDone animated:YES];
//                if (percentDone == 100) {
//                    self.progressview.hidden = YES;
//                    [MBProgressHUD showSuccess:@"图片上传成功"];
//                }
//            }];
//            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (error) {
//                    NSLog(@"保存失败");
//                }
//            }];
//            
//            
//        }
//        else
//        {
//            AVUser *user = [AVUser currentUser];
//            data = UIImagePNGRepresentation(image);
//            AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png", user.username] data:data];
//            
//            
//            [user setObject:file forKey:@"touxiang"];
//            
//            
//            
//            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                
//            } progressBlock:^(NSInteger percentDone) {
//                [self.progressview setProgress:percentDone animated:YES];
//                if (percentDone == 100) {
//                    self.progressview.hidden = YES;
//                    [MBProgressHUD showSuccess:@"图片上传成功"];
//                }
//            }];
//            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (error) {
//                    NSLog(@"保存失败");
//                }
//            }];
//            
//            
//        }
        
        
    }
    
}
/**
 *  添加scrollview中的三个子view
 */
- (void)addchildviews
{
    CGFloat scrollW = self.midScrollView.frame.size.width;
    CGFloat scrollH = self.midScrollView.frame.size.height;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    view1.backgroundColor = [UIColor whiteColor];
    registerView1 *view1child = (registerView1 *)[self loadnibwithname:@"registerView1"];
    view1child.delegate =self;
    view1child.frame = CGRectMake((scrollW - view1child.frame.size.width) / 2, 0, view1child.frame.size.width, view1child.frame.size.height);
    [view1 addSubview:view1child];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(scrollW, 0, scrollW, scrollH)];
    view2.backgroundColor = [UIColor whiteColor];
    registerView2 *view2child = (registerView2 *)[self loadnibwithname:@"registerView2"];
    view2child.delegate  =self;
    view2child.frame = view1child.frame;
    [view2 addSubview:view2child];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(scrollW *2, 0, scrollW, scrollH)];
    view3.backgroundColor = [UIColor whiteColor];
    registerView3 *view3child = (registerView3 *)[self loadnibwithname:@"registerView3"];
    view3child.frame = view1child.frame;
    view3child.delegate = self;
    [view3 addSubview:view3child];
    
    [self.midScrollView addSubview:view1];
    [self.midScrollView addSubview:view2];
    [self.midScrollView addSubview:view3];
    
}


- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)bottomBtnclick {
    CGFloat scrollW = self.midScrollView.frame.size.width;
    CGFloat scrollH = self.midScrollView.frame.size.height;
    if (self.index == 1) {
        [self.midScrollView scrollRectToVisible:CGRectMake(scrollW, 0, scrollW, scrollH) animated:YES];
        self.index =2;
        
    }else if (self.index == 2)
    {
        [self.midScrollView scrollRectToVisible:CGRectMake(scrollW*2, 0, scrollW, scrollH) animated:YES];
        self.index =3;
    }
    [self setBtnStatuWithnum:self.index];
    
    
    
    
}
/**
    根据nib名字返回相应的view
 */

- (UIView *)loadnibwithname:(NSString *)name
{
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject];
}
/**
 scrollview代理方法，监听scrollview的滚动
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat x = targetContentOffset->x;
    if (x== 640) {
        self.index = 3;
    }else if (x== 320)
    {
        self.index = 2;
    }
    else
    {
        self.index = 1;
    }
    [self setBtnStatuWithnum:self.index];
    
}
/**
    设置底部btn的旋转
 */
- (void)setBtnStatuWithnum:(NSInteger)index
{
    if (index == 3) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }];
        
        
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
        self.bottomBtn.transform =  CGAffineTransformIdentity;
            }];
    }
}

//- (UIImageView *)addseDivideLine
//{
//    UIImageView *view =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 1)];
//    view.image = [UIImage imageNamed:@""];
//}

- (void)PasswdagainTextfieldEndedit
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformIdentity;
    }];
}

- (void)PasswdagainTextfieldBeginedit
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

- (void)signatureTextfieldBeginedit
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

- (void)signatureTextfieldEndedit
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformIdentity;
    }];
}


- (void)choosebithday
{
    self.birthdaypicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 100)];
    self.birthdaypicker.datePickerMode = UIDatePickerModeDate;
    self.birthdaypicker.backgroundColor = [UIColor blueColor];
    [self.birthdaypicker addTarget:self action:@selector(datachange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.birthdaypicker];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216,self.view.frame.size.width , 30)];
    view.backgroundColor = [UIColor redColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 50, 30);
    //    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
    [btn1 setTitle:@"完成" forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn1 addTarget:self action:@selector(finishchoosebirthday) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    self.birthdaypicktoolbar = view;

    
    [self.view addSubview:view];
    
    
    
}

- (void)finishchoosebirthday
{
    self.birthdaypicker.hidden = YES;
    self.birthdaypicktoolbar.hidden = YES;
    NSLog(@"%@", self.birthdaypdate);
    
}

- (void)datachange:(UIDatePicker *)date
{
    self.birthdaypdate = date.date;
}

- (void)chooseschool
{
    
}

@end
