//
//  addcommentVC.h
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@interface addcommentVC : UIViewController
@property (strong ,nonatomic) AVUser *fromuser;
@property (strong ,nonatomic) AVUser *touser;
@property (strong ,nonatomic) AVObject *activiobj;
@end
