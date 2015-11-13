//
//  NSObject+LX.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-29.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
@interface NSObject (LX)
+ (BOOL) connectedToNetwork;
+ (NSString*  )connectwithnum;
+ (CGRect )setVCviewframewithinchs;
+ (CGFloat )settableviewcellsizewithinchs;
+ (NSMutableArray *)getlibraryswithlocation:(CLLocation *)location;


@end
