//
//  alljoinusersCell.h
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@interface alljoinusersCell : UITableViewCell
@property (nonatomic ,strong) AVUser *user;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@end
