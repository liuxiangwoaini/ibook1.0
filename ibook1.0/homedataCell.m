//
//  homedataCell.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "homedataCell.h"
#import "NSString+LX.h"
@interface homedataCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *target;
@end
@implementation homedataCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.title.text = dict[@"title"];
    self.remark.text = dict[@"remark"];
    self.place.text = dict[@"place"];
    self.type.text = [NSString activitype:[dict[@"type"] intValue]];
    self.target.text = [NSString activitarget:[dict[@"target"] intValue]];
    
}
//-(void)setFrame:(CGRect)frame {
//    CGFloat y = frame.origin.y +10;
//    CGRect rect = CGRectMake(frame.origin.x,y , frame.size.width, frame.size.height);
//    self.contentView.frame = rect;
//    [super setFrame:frame];
//}
@end
