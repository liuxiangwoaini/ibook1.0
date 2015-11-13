//
//  LXLocation.h
//  ibook1.0
//
//  Created by liuxiang on 15-11-13.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LXLocation : NSObject
- (NSMutableArray *)getlibraryswithlocation:(CLLocation *)location;
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;
@end
