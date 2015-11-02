//
//  addcommentVC.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "addcommentVC.h"
#import "MBProgressHUD+MJ.h"
#import "NSNumber+LX.h"
@interface addcommentVC ()<UIActionSheetDelegate>
- (IBAction)sendcomment;
@property (weak, nonatomic) IBOutlet UITextView *commentfiled;

@end

@implementation addcommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close {
    if (!self.commentfiled.text.length) {
         [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    

   
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"要取消发送吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [action showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

//{
//    "atyObjId": "5630b98a60b20fc9ded85bc3",
//    "toUserNickname": "",
//    "content": "还会有好",
//    "commentType": 15018,
//    "fromUser": {
//        "__type": "Pointer",
//        "className": "_User",
//        "objectId": "5629db7300b0a6792c0c50d3"
//    },
//    "toUserObjId": "55fd3bc660b2af39552a1b18",
//    "ACL": {
//        "*": {
//            "read": true,
//            "write": true
//        }
//    },
//    "objectId": "5630c10d00b0bf376c3b564b",
//    "createdAt": "2015-10-28T20:35:25.047Z",
//    "updatedAt": "2015-10-28T20:35:25.047Z"
//}
- (IBAction)sendcomment {
    if (!self.commentfiled.text.length) {
        [MBProgressHUD showError:@"请填写内容"];
        return;
    }
    
    
        [MBProgressHUD showMessage:@"正在发送..."];
    AVObject *post = [AVObject objectWithClassName:@"Comment"];
   
    [post setObject:self.activiobj.objectId forKey:@"atyObjId"];
    [post setObject:self.commentfiled.text forKey:@"content"];
    [post setObject:@(15018) forKey:@"commentType"];
    [post setObject:@"" forKey:@"toUserNickname"];
    [post setObject:self.fromuser forKey:@"fromUser"];
    [post setObject:self.touser.objectId forKey:@"toUserObjId"];
    
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"发送成功"];
                NSNumber *newcomment = [NSNumber add:self.activiobj[@"commentCount"] and:[NSNumber numberWithInt:1]];
                [self.activiobj setObject:newcomment forKey:@"commentCount"];
                [self.activiobj saveInBackground];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendcomment" object:nil];
                
            }else
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"发送失败..."];
            }
        }];
    
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
