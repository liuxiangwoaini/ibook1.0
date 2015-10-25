//
//  iBookUser.m
//  ibook1.0
//
//  Created by liuxiang on 15-10-23.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "iBookUser.h"
#import <AVOSCloud/AVOSCloud.h>
@implementation iBookUser

+ (instancetype)userwithdict:(NSDictionary *)dict
{
    return [[self alloc] initwithdict:dict];
}
//- (instancetype)initwithdict:(NSDictionary *)dict
//{
//    if (self = [super init]) {
//        self.username = dict[@""];
//        
//        
//    }
//    return self;
//}
- (instancetype)initWithdict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        self.icon = dict[@"icon"];
//        self.title = dict[@"title"];
//        self.scheme = dict[@"customUrl"];
//        self.url = dict[@"url"];
//        self.identifier = dict[@"id"];
        //        [self setValuesForKeysWithDictionary:dict];
        
        self.school = dict[@"school"];
        self.signature = dict[@"signature"];
        self.nickname = dict[@"nickname"];
        self.username = dict[@"username"];
        self.mobilePhoneNumber = dict[@"mobilePhoneNumber"];
        self.avatarUrl = dict[@"avatarUrl"];
//        self.birth = dict[@""];
    }
    return self;
}






@end
