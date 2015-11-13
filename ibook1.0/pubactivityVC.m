//
//  pubactivityVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//
#import <AVOSCloud/AVOSCloud.h>
#import "pubactivityVC.h"
#import "MBProgressHUD+MJ.h"
#import "NSNumber+LX.h"

@interface pubactivityVC ()<UIActionSheetDelegate, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *beizhu;
@property (weak, nonatomic) IBOutlet UITextField *theme;

@property (weak, nonatomic) IBOutlet UITextField *place;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (strong , nonatomic) UITableView *tableview;
@property (strong ,nonatomic) NSMutableArray *datas;
@property (assign ,nonatomic) NSInteger index;
@property (assign ,nonatomic) NSInteger dateindex;
@property (strong, nonatomic) NSDate *pubdate;
- (IBAction)pub;
@end


@implementation pubactivityVC
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headlabel.text = self.title;
    self.beizhu.delegate =self;
    self.place.delegate =self;
    self.type.delegate =self;
    self.time.delegate =self;
    UITableView *table = [[UITableView alloc] init];
    table.hidden = YES;
    table.dataSource =self;
    table.delegate =self;
    self.tableview = table;
    [self.view addSubview:table];
   
}

- (IBAction)close {
   
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"要取消发送吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [action showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.tableview.hidden = YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 2:
        {
            [self.view endEditing:YES];
            self.tableview.hidden = NO;
            self.tableview.frame =CGRectMake(self.place.frame.origin.x, CGRectGetMaxY(self.place.frame) +10, self.view.frame.size.width - 61, 200);
            NSString *path = [[NSBundle mainBundle] pathForResource:@"schools.plist" ofType:nil];
            self.datas = [NSMutableArray arrayWithContentsOfFile:path];
            [self.tableview reloadData];
            self.index = 2;
            
            
            break;
        }
        case 3:
        {
            [self.view endEditing:YES];
            self.tableview.hidden = NO;
            self.tableview.frame =CGRectMake(self.time.frame.origin.x, CGRectGetMaxY(self.time.frame) +10, 131, 170);
            self.datas = (NSMutableArray *)@[@"1天",@"7天", @"15天",@"30天"];
             [self.tableview reloadData];
            self.index = 3;
            
            break;
        }
        case 4:
        {
            [self.view endEditing:YES];
            self.tableview.hidden = NO;
            self.tableview.frame =CGRectMake(self.type.frame.origin.x, CGRectGetMaxY(self.type.frame) +10, 131, 130);
            self.datas = (NSMutableArray *)@[@"仅限男生",@"仅限女生", @"男女不限"];
            [self.tableview reloadData];
            self.index  =4;
            
            break;
            
        }
        case 5:
        {
            [self.view becomeFirstResponder];
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform =CGAffineTransformMakeTranslation(0, -100);
            }];
            break;
        }
        default:
            break;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    self.tableview.hidden = YES;
}

- (IBAction)pub {
    if (!self.theme.text.length ||!self.place.text.length ||!self.time.text.length||!self.type.text.length||!self.beizhu.text.length) {
        [MBProgressHUD showError:@"请填写完全"];
        return;
    }
    [self setuppubdate];
    AVUser *user = [AVUser currentUser];
    [MBProgressHUD showMessage:@"正在发布..."];
    AVObject *post = [AVObject objectWithClassName:@"Activities"];
    
    [post setObject:self.beizhu.text forKey:@"remark"];
    [post setObject:self.place.text forKey:@"place"];
    [post setObject:@(1) forKey:@"isUseful"];
    int type = [NSNumber activitytypewith:self.title];
    [post setObject:@(type) forKey:@"type"];
    [post setObject:self.title forKey:@"title"];
    [post setObject:@(0) forKey:@"commentCount"];
    int target = [NSNumber activitytargetwith:self.type.text];
    [post setObject:@(target) forKey:@"target"];
    [post setObject:@(0) forKey:@"applyCount"];
    [post setObject:user forKey:@"owner"];
    [post setObject:user[@"lastLocation"] forKey:@"pubLocation"];
    [post setObject:self.pubdate forKey:@"endTime"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"发布成功"];
      
            [self dismissViewControllerAnimated:YES completion:nil];
    
            
        }else
        {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"发送失败..."];
        }
    }];

    
}
- (void)setuppubdate
{
    switch (self.dateindex) {
            //1
        case 0:
        {
            self.pubdate = [NSDate dateWithTimeIntervalSinceNow:86400];
            
            break;
        }
            //7
        case 1:
        {
            self.pubdate = [NSDate dateWithTimeIntervalSinceNow:86400 *7];
            break;
        }
            // 15
        case 2:
        {
            self.pubdate = [NSDate dateWithTimeIntervalSinceNow:86400 *15];
            break;
        }
            //30
        default:
        {
            self.pubdate = [NSDate dateWithTimeIntervalSinceNow:86400 * 30];
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.datas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"pubtable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableview.hidden = YES;
    
    switch (self.index) {
        case 2:
        {
            self.place.text = self.datas[indexPath.row];
            break;
        }
        case 3:
        {
            
            self.time.text = self.datas[indexPath.row];
            self.dateindex = indexPath.row;
            break;
        }
        case 4:
        {
            self.type.text = self.datas[indexPath.row];
            break;
        }
        default:
            break;
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
////    if (textField.tag == 5) {
////        [self.view endEditing:YES];
////        self.tableview.hidden = YES;
////    }
//    return YES;
//}
@end
