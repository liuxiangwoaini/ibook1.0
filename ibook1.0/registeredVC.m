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
#import "MBProgressHUD+MJ.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NSObject+LX.h"
#import "BTViewController.h"
@interface registeredVC ()<UIScrollViewDelegate, registerView1Delagate,registerView2Delagate,UIImagePickerControllerDelegate, registerView3Delagate, UITableViewDataSource, UITableViewDelegate,BTViewControllerdelegate>
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

@property (nonatomic, strong) registerView3 *register3;
@property (nonatomic, strong) registerView2 *register2;
@property (nonatomic, strong) registerView1 *register1;
@property (nonatomic, strong) UITableView *chooseschooltable;
@property (nonatomic ,strong) NSMutableArray *schools;
@property (nonatomic, strong) UIView *backgroundview;
@property (nonatomic, strong) AVFile *touxiang;
@property (nonatomic, strong) UIButton *addbtn;
@property (assign, nonatomic, getter=isChooseHeadImage) BOOL ChooseHeadImage;
@property (assign, nonatomic) NSInteger gender;

/**
 *  底部btn的点击
 */

- (IBAction)bottomBtnclick;


@end

@implementation registeredVC


- (NSMutableArray *)schools
{
    if (_schools == nil) {
        NSString *path1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *libdatapath = [path1 stringByAppendingPathComponent:@"libsdata"];
        
        _schools = [NSMutableArray arrayWithContentsOfFile:libdatapath];
        
    }
    return _schools;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [NSObject setVCviewframewithinchs];
    [self setupscrollview];
    self.index = 1;
    self.birthdaypdate = [NSDate date];
    self.ChooseHeadImage = NO;
    [self setAddheadimage];
    
    
    
    
}

- (void)setAddheadimage
{
    CGFloat scrollW = self.midScrollView.frame.size.width;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width*0.5- 40 , 30, 80, 80);
    //    btn.backgroundColor = [UIColor redColor];
    UIImage *backimage = [UIImage circleImageWithName:@"avatar_default_add.png" borderWidth:1 borderColor:IBColor(238, 238, 238)];
    
    [btn setImage:backimage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addheadimage) forControlEvents:UIControlEventTouchUpInside];
    self.addbtn = btn;
    [self.view addSubview:btn];
}

/**
 *  初始化scrollview
 */
- (void)setupscrollview
{
    CGFloat width =self.view.frame.size.width;
    self.midScrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, 260);
    self.midScrollView.pagingEnabled =  YES;
    self.midScrollView.showsHorizontalScrollIndicator = NO;
    self.midScrollView.delegate = self;
    [self addchildviews];
    
    
}
#warning 写到这里，明天继续
- (void)addheadimage
{
    
    if (self.register1.username.text.length !=11 )
    {
        [MBProgressHUD showError:@"手机号码位数不对"];
        self.register2.send = NO;
        return;
    }
    else if (![self isPureInt:self.register1.username.text] )
    {
        [MBProgressHUD showError:@"手机号码格式不对"];
        self.register2.send = NO;
        return;
    }

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
//        //先把图片转成NSData
//        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagepath = [path stringByAppendingPathComponent:@"touxiang.png"];
        UIImage *backimage = [self circleImage:image withParam:1];
        [self.addbtn setImage:backimage forState:UIControlStateNormal];
        self.ChooseHeadImage = YES;
        NSData *data;
//#warning 不知道返回的图片的扩展名。。。。。搜也搜不到
                if (UIImagePNGRepresentation(image))
                {

                    data = UIImageJPEGRepresentation(image, 1.0);
                    
//                    [data writeToFile:imagepath atomically:YES];
                    AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.jpg", self.register1.username.text] data:data];
                    
                    
                    
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"chengg");
                        }else
                        {
                            NSLog(@"shibai");
                        }
                    }];

                    

        
        
        
                    
        
        
        
                }
                else
                {

                    data = UIImagePNGRepresentation(image);
//                    [data writeToFile:imagepath atomically:YES];
                    AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png", self.register1.username.text] data:data];
                    
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"chengg");
                        }else
                        {
                            NSLog(@"shibai");
                        }
                    }];
                    
                    

  

        
       
    
}
    }
    

    
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
/**
 *  添加scrollview中的三个子view
 */
        
        
- (void)addchildviews
{
    CGFloat scrollW = self.view.frame.size.width;
    CGFloat scrollH = 260;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    view1.backgroundColor = [UIColor whiteColor];
    registerView1 *view1child = (registerView1 *)[self loadnibwithname:@"registerView1"];
    view1child.delegate =self;
    view1child.frame = CGRectMake(0, 0, self.view.frame.size.width, 260);
    self.register1 = view1child;
    [view1 addSubview:view1child];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(scrollW, 0, scrollW, scrollH)];
    view2.backgroundColor = [UIColor whiteColor];
    registerView2 *view2child = (registerView2 *)[self loadnibwithname:@"registerView2"];
    view2child.delegate  =self;
    view2child.frame = view1child.frame;
    self.register2 = view2child;
    [view2 addSubview:view2child];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(scrollW *2, 0, scrollW, scrollH)];
    view3.backgroundColor = [UIColor whiteColor];
    registerView3 *view3child = (registerView3 *)[self loadnibwithname:@"registerView3"];
    view3child.frame = view1child.frame;
    view3child.delegate = self;
    self.register3 = view3child;
    [view3 addSubview:view3child];
    
    [self.midScrollView addSubview:view1];
    [self.midScrollView addSubview:view2];
    [self.midScrollView addSubview:view3];
    
}


- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)bottomBtnclick {
   [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
   }];
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
    else
    {
        if (self.register2.Verificationcode.text.length != 6 || ![self isPureInt:self.register2.Verificationcode.text]) {
            [MBProgressHUD showError:@"验证码错误"];
            
        }else if (!self.register2.nickname.text.length || !self.register2.signature.text.length)
        {
            [MBProgressHUD showError:@"昵称或者签名没写"];
        }else if (!self.register3.birthdaylable.text.length || !self.register3.schoollable.text.length)
        {
            [MBProgressHUD showError:@"学校或者生日没选"];
        }
        else if (!self.register3.boyBtn.selected && !self.register3.girlBtn.selected)
        {
            [MBProgressHUD showError:@"选择性别"];
        }
        else
        {
            if (self.register3.boyBtn.selected) {
                self.gender = 1;
            }
            [AVUser verifyMobilePhone:self.register2.Verificationcode.text withBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [MBProgressHUD showSuccess:@"注册成功"];
                    NSString *full = [NSString stringWithFormat:@"%@.jpg", self.register1.username.text];
                    NSString *full1 = [NSString stringWithFormat:@"%@.png", self.register1.username.text];
                    AVQuery *query = [AVQuery queryWithClassName:@"_File"];
                    __block NSString *imageurl;
                    [query whereKey:@"name" equalTo:full];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            // 检索成功
                            NSDictionary *dict = [objects lastObject];
                            imageurl = dict[@"localData"][@"url"];
//                            imageurl = (NSString *)file[@"url"];
                            NSLog(@"%@", imageurl);
                        } else {
                            // 输出错误信息
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                    
                    [AVUser logInWithUsername:self.register1.username.text password:self.register1.passwd.text error:nil];
                    AVUser *user = [AVUser currentUser];
                    
                            [user setObject:self.register3.schoollable.text forKey:@"school"];
                            [user setObject:self.register2.signature.text forKey:@"signature"];
                            [user setObject:self.register2.nickname.text forKey:@"nickname"];
                            [user setObject:@(self.gender) forKey:@"gender"];
                            [user setObject:self.birthdaypdate forKey:@"birth"];
                    [user setObject:imageurl forKey:@"avatarUrl"];
//                            [user setObject:self.touxiang forKey:@"touxiang"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"chengg");
                        }else
                        {
                            NSLog(@"shibai");
                        }
                    }];
                    

                    

                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else
                {
                    [MBProgressHUD showError:@"注册失败"];
                }
            }];
            
            
        }
    }
    [self setBtnStatuWithnum:self.index];
    
    
    
    
}


//    AVQuery *query = [AVUser query];
//    [query whereKey:@"username" equalTo:@"18345189176"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error == nil) {
//            AVUser *user = [objects lastObject];
////            [user setObject:self.register3.schoollable.text forKey:@"school"];
////            [user setObject:self.register2.signature.text forKey:@"signature"];
////            [user setObject:self.register2.nickname.text forKey:@"nickname"];
////            [user setObject:@(self.gender) forKey:@"gender"];
////            [user setObject:self.register3.birthdaylable.text forKey:@"birth"];
////            [user setObject:self.touxiang forKey:@"touxiang"];
//            [user setObject:@"dasd" forKey:@"das"];
//            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    NSLog(@"chengg");
//                }else
//                {
//                    NSLog(@"shibai");
//                }
//            }];
//        } else {
//            
//        }
//    }];
//    [AVUser logInWithUsername:@"18345189176" password:@"123456" error:nil];

//    [AVUser logInWithUsername:@"18345189176" password:@"123456" error:nil];
//    AVUser *user = [AVUser currentUser];
//    
////    [user setObject:self.register3.schoollable.text forKey:@"school"];
////    [user setObject:self.register2.signature.text forKey:@"signature"];
////    [user setObject:self.register2.nickname.text forKey:@"nickname"];
////    [user setObject:@(self.gender) forKey:@"gender"];
////    [user setObject:self.birthdaypdate forKey:@"birth"];
//    [user setObject:self.touxiang forKey:@"touxiang"];
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"chengg");
//        }else
//        {
//            NSLog(@"shibai");
//        }
//    }];
    
//    NSString *full = [NSString stringWithFormat:@"11111111111.jpg"];
////    NSString *full1 = [NSString stringWithFormat:@"%@.png", self.register1.username.text];
//    AVQuery *query = [AVQuery queryWithClassName:@"_File"];
//    __block NSString *imageurl;
//    [query whereKey:@"name" equalTo:full];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // 检索成功
//            NSDictionary *dict = (NSDictionary *)[objects lastObject];
//            NSLog(@"%@", dict[@"localData"][@"url"]);
//            AVUser *user = [AVUser currentUser];
//            [user setObject:dict[@"localData"][@"url"] forKey:@"avatarUrl"];
//                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (succeeded) {
//                        NSLog(@"chengg");
//                    }else
//                    {
//                        NSLog(@"shibai");
//                    }
//                }];
//            
//            
//        } else {
//            // 输出错误信息
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    

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
    if (x== self.view.frame.size.width*2) {
        self.index = 3;
    }else if (x==self.view.frame.size.width )
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
    
    NSString *temp = [[NSString stringWithFormat:@"%@", self.birthdaypdate] substringToIndex:10];
    self.register3.birthdaylable.text = temp;
    
}

- (void)datachange:(UIDatePicker *)date
{
    self.birthdaypdate = date.date;
}

- (void)chooseschool
{
//    if (self.chooseschooltable && self.backgroundview) {
//        self.backgroundview.hidden = NO;
//        self.chooseschooltable.hidden = NO;
//        return;
//    }
//    self.backgroundview  =[[UIView alloc] initWithFrame:self.view.bounds];
//    self.backgroundview.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:self.backgroundview];
//    self.chooseschooltable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5- 130, 80, 260, 300) style:UITableViewStylePlain];
//    self.chooseschooltable.delegate = self;
//    self.chooseschooltable.dataSource  =self;
//    [self.view addSubview:self.chooseschooltable];
    BTViewController *bt = [[BTViewController alloc] init];
    bt.delegate =self;
    [self presentViewController:bt animated:YES completion:nil];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.schools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"hehe";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text =self.schools[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.backgroundview.hidden = YES;
    self.chooseschooltable.hidden = YES;
    self.register3.schoollable.text = self.schools[indexPath.row];
}

- (void)sendVerificationBtnClick
{
    if (self.register1.username.text.length !=11 )
    {
        [MBProgressHUD showError:@"手机号码位数不对"];
        self.register2.send = NO;
        return;
    }
    else if (![self isPureInt:self.register1.username.text] )
    {
        [MBProgressHUD showError:@"手机号码格式不对"];
        self.register2.send = NO;
        return;
    }
    else if (![self.register1.passwd.text isEqualToString:self.register1.passwdagain.text])
    {
        [MBProgressHUD showError:@"密码不对"];
        self.register2.send = NO;
        return;
    }
    
    
    
    
    
    AVUser *user = [AVUser user];
    user.username =self.register1.username.text;
    user.password =self.register1.passwd.text;
    user.mobilePhoneNumber =self.register1.username.text;
    NSError *error = nil;
    [user signUp:&error];
    if (error) {
        NSLog(@"shibai--%@", error.description);
    }
    self.register2.send = YES;
    
    
    
}

- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

- (void)BTViewControllerchooseschoolname:(NSString *)name
{
    self.register3.schoollable.text = name;
}

@end
