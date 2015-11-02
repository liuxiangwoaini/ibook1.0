//
//  NSString+LX.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-25.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "NSString+LX.h"

@implementation NSString (LX)
+ (NSString *)activitype:(NSInteger )num
{
    switch (num) {
        case 15001:
            return @"陪看书";
            break;
        case 15002:
            return @"去自习";
            break;
        case 15003:
            return @"找书友";
            break;
        case 15004:
            return @"换本书";
            break;
        case 15005:
            return @"求教材";
            break;
            
        default:
            return @"求补课";
            break;
    }
}

+ (NSString *)activitarget:(NSInteger)num
{
    switch (num) {
        case 15007:
            return @"仅限男生";
            break;
        case 15008:
            return @"仅限男生";
            break;
            
            
        default:
            return @"男女不限";
            break;
    }
}
@end
