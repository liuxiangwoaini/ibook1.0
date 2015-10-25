//
//  PersonAcitiviCell.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-25.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonAcitiviCell : UITableViewCell
//@property (nonatomic ,strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *type;
@end
