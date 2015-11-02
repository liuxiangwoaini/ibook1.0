//
//  NSNumber+LX.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "NSNumber+LX.h"

@implementation NSNumber (LX)
+(NSNumber*)add:(NSNumber *)one and:(NSNumber *)anotherNumber
{
    return [NSNumber numberWithFloat:[one floatValue] + [anotherNumber floatValue]];
}
+ (int )activitytypewith:(NSString *)string
{
    if ([string isEqualToString:@"陪看书"]) {
        return 15001;
    }else if ([string isEqualToString:@"去自习"])
    {
        return 15002;
    }
    else if ([string isEqualToString:@"找书友"])
    {
        return 15003;
    }else if ([string isEqualToString:@"换本书"])
    {
        return 15004;
    }else if ([string isEqualToString:@"求教材"])
    {
        return 15005;
    }else if ([string isEqualToString:@"求补课"])
    {
        return 15006;
    }
    else
    {
        return 15001;
    }
    
}
+ (int )activitytargetwith:(NSString *)string
{
    if ([string isEqualToString:@"仅限男生"]) {
        return 15007;
    }else if ([string isEqualToString:@"仅限女生"])
    {
        return 15008;
    }
    else if ([string isEqualToString:@"男女不限"])
    {
        return 15009;
    }else
    {
        return 15007;
    }
}
@end
