//
//  activitydetailVC.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@protocol activitydetailVCdelegate<NSObject>


- (void)activitydetailVCclickheadbtnwithuserdata:(AVUser *)user;
@end
@interface activitydetailVC : UIViewController
@property (nonatomic ,strong) AVObject *obj;
@property (nonatomic, strong) NSDictionary *dict;
@property (assign, nonatomic) id<activitydetailVCdelegate> delegate;
@end
