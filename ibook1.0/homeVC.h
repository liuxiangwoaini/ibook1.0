//
//  homeVC.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@protocol homeVCdelegate <NSObject>


- (void)changedetailactiviVCwithdata:(AVObject *)data anddict:(NSDictionary *)dict;
- (void)changetouserdata:(AVUser *)user;
- (void)pubactivityVCwithtitle:(NSString *)tilte;
@end

@interface homeVC : UIViewController
@property (assign, nonatomic) id<homeVCdelegate> delegate;
@end
