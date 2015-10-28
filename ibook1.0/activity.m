//
//  activity.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "activity.h"

@implementation activity
- (instancetype)initWithdict:(NSDictionary *)dict
{
    if (self = [super init]) {
            
        self.title  =dict[@"title"];
        self.remark = dict[@"remark"];
        self.place = dict[@"place"];
        self.target = dict[@"target"];
        self.type = dict[@"type"];
        self.isuseful =dict[@"isUseful"];
        
    }
    return self;
}

+ (instancetype)activitywithdict:(NSDictionary *)dict
{
    return [[self alloc] initWithdict:dict];
}
@end
