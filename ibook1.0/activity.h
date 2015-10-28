//
//  activity.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-28.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//
//"remark": "图兔兔吐了",
//"place": "哈尔滨理工大学南校区图书馆",
//"isUseful": 0,
//"type": 15006,
//"title": "今天真是的",
//"commentCount": 1,
//"target": 15009,
//"applyCount": 0,
//"owner": {
//    "__type": "Pointer",
//    "className": "_User",
//    "objectId": "55fab8f1ddb2dd0026b2e42c"
//},
//"ACL": {
//    "*": {
//        "read": true,
//        "write": true
//    }
//},
//"endTime": {
//    "__type": "Date",
//    "iso": "2015-09-24T21:09:57.919Z"
//},
//"pubLocation": {
//    "__type": "GeoPoint",
//    "latitude": 45.70801,
//    "longitude": 126.627673
//},
//"objectId": "55fabba760b2849751b8905c",
//"createdAt": "2015-09-17T21:09:59.537Z",
//"updatedAt": "2015-10-21T18:16:52.339Z"

#import <Foundation/Foundation.h>

@interface activity : NSObject
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *remark;
@property (nonatomic ,copy) NSString *place;
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,assign) NSInteger target;
@property (nonatomic ,assign) BOOL isuseful;


+ (instancetype)activitywithdict:(NSDictionary *)dict;
- (instancetype)initWithdict:(NSDictionary *)dict;
@end
