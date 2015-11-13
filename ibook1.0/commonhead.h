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

#endif
