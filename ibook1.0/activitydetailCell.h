//
//  activitydetailCell.h
//  ibook1.0
//
//  Created by liuxiang on 15-11-1.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@protocol activitydetailCelldelegate <NSObject>


- (void)clickactivitydetailheadbtnwithuserdata:(AVUser *)user;
@end
@interface activitydetailCell : UITableViewCell
@property (nonatomic ,strong) AVObject *obj;
@property (assign, nonatomic) id<activitydetailCelldelegate> delegate;
@end
