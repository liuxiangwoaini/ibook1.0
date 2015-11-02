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
@end
