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
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 获得RGB颜色
#define IBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define IBScreenFrame [[UIScreen mainScreen] bounds]
#endif
