//
//  commonhead.h
//  ibook1.0
//
//  Created by liuxiang on 15-10-18.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#ifndef ibook1_0_commonhead_h
#define ibook1_0_commonhead_h

// 判断是否为iOS7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 获得RGB颜色
#define IBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define IBScreenFrame [[UIScreen mainScreen] bounds]

#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iphone4and4s ([UIScreen mainScreen].bounds.size.height == 480)
#define iphone5and5s ([UIScreen mainScreen].bounds.size.height == 568)
#define iphone6and6s ([UIScreen mainScreen].bounds.size.height == 667)
#define iphone6plusand6spus ([UIScreen mainScreen].bounds.size.height == 736)


#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#pragma mark - 设备型号识别
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#pragma mark - 硬件
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif
