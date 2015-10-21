//
//  registerView3.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-19.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol registerView3Delagate <NSObject>

@optional
- (void)choosebithday;
- (void)chooseschool;
@end
@interface registerView3 : UIView
@property (weak, nonatomic) id<registerView3Delagate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *birthdaylable;
@property (weak, nonatomic) IBOutlet UILabel *schoollable;
/**
 *   选择性别的btn
 */
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;

@end
