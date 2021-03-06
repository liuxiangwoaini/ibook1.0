//
//  homedataCell.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@protocol homedataCelldelegate <NSObject>


- (void)clickheadbtnwithuserdata:(AVUser *)user;
@end

@interface homedataCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic ,strong) AVObject *obj;
@property (assign, nonatomic) id<homedataCelldelegate> delegate;
@end
