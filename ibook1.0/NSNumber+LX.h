//
//  NSNumber+LX.h
//  ibook1.0
//
//  Created by liuxiang on 15-11-2.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (LX)
+(NSNumber*)add:(NSNumber *)one and:(NSNumber *)anotherNumber;
+ (int )activitytypewith:(NSString *)string;
+ (int )activitytargetwith:(NSString *)string;
@end
