//
//  changuserdataVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "changuserdataVC.h"
#import "MBProgressHUD+MJ.h"

@interface changuserdataVC ()<UIActionSheetDelegate>
- (IBAction)back:(id)sender;
- (IBAction)save;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
/**
 签名
 */
- (IBAction)choosebirthday;


@property (nonatomic, strong) UIView *birthdaypicktoolbar;
@property (weak, nonatomic) IBOutlet UITextField *signature;
@property (weak, nonatomic) IBOutlet UILabel *birthdaylable;
@property (weak, nonatomic) IBOutlet UITextField *school;

@property (strong, nonatomic) UIDatePicker *birthdaypicker;

@property (nonatomic, strong) NSDate *birthdaypdate;
@end

@implementation changuserdataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    AVUser *user = [AVUser currentUser];
    self.nickname.text = user[@"nickname"];
    self.signature.text = user[@"signature"];
    self.birthdaylable.text = [[user[@"birth"] description] substringToIndex:10];
//    self.schoollable.text = user[@"school"];
    self.school.text =user[@"school"];
}



- (IBAction)back:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"要取消保存吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [action showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

- (IBAction)save {
    
    if (self.nickname.text.length && self.signature.text.length && self.school.text.length) {
        [MBProgressHUD showMessage:@"正在保存"];
//        [self performSelector:@selector(close) withObject:self afterDelay:3];
        AVUser *user = [AVUser currentUser];
        [user setObject:self.nickname.text forKey:@"nickname"];
        [user setObject:self.signature.text forKey:@"signature"];
        [user setObject:self.school.text forKey:@"school"];
        [user setObject:self.birthdaypdate forKey:@"birth"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"保存失败..."];
            }
        }];
        
    }else
    {
        [MBProgressHUD showError:@"没填完全..."];
    }

    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)close
{
    [MBProgressHUD hideHUD];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)choosebirthday {
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



- (void)datachange:(UIDatePicker *)date
{
    self.birthdaypdate = date.date;
}

- (void)finishchoosebirthday
{
    self.birthdaypicker.hidden = YES;
    self.birthdaypicktoolbar.hidden = YES;
    
    NSString *temp = [[NSString stringWithFormat:@"%@", self.birthdaypdate] substringToIndex:10];
    self.birthdaylable.text = temp;
    
}
@end
