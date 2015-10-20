//
//  registerView3.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "registerView3.h"
@interface registerView3()
/**
 *   选择性别的btn
 */
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;

/**
 *  选择性别btn的点击
 */
- (IBAction)gitlBtnClick;
- (IBAction)boyBtnClick;
/**
 *  选择生日
 */
- (IBAction)chooseBirthday;
/**
 *  选择城市
 */
- (IBAction)chooseCity;
@end
@implementation registerView3

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (IBAction)gitlBtnClick {
    self.girlBtn.selected = !self.girlBtn.selected;
    if (self.boyBtn.selected) {
        self.boyBtn.selected = NO;
    }
    
}

- (IBAction)boyBtnClick {
    self.boyBtn.selected = !self.boyBtn.selected;
    if (self.girlBtn.selected) {
        self.girlBtn.selected = NO;
    }
}

- (IBAction)chooseBirthday {
    if ([self.delegate respondsToSelector:@selector(choosebithday)]) {
        [self.delegate choosebithday];
    }
    
}

- (IBAction)chooseCity{
    if ([self.delegate respondsToSelector:@selector(chooseschool)]) {
        [self.delegate chooseschool];
    }
    
}
@end
