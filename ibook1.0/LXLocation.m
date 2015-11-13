//
//  LXLocation.m
//  ibook1.0
//
//  Created by liuxiang on 15-11-13.
//  Copyright (c) 2015年 liuxiang. All rights reserved.
//

#import "LXLocation.h"
#define Baidulocationapikey @"1457ac3d0f915dfd1d64757c49d811ff"
@interface LXLocation()
@property (strong, nonatomic) NSMutableArray *data;
@end
@implementation LXLocation

- (void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: Baidulocationapikey forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%d", error.localizedDescription, error.code);
                               } else {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSArray *array = dict[@"retData"];
                                   [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                       [self.data addObject:obj[@"name"]];
                                   }];
                               }
                           }];
}

- (NSMutableArray *)getlibraryswithlocation:(CLLocation *)location
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/lbswebapi/placeapi_circleregion";
    NSString *httpArg = @"location=38.76623%2C116.43213&radius=2000000&query=%E5%9B%BE%E4%B9%A6%E9%A6%86&scope=1";;
    //    NSString *httpArg = [NSString stringWithFormat:@"location=38.76623,116.43213&radius=2000&query=%E9%93%B6%E8%A1%8C%0A&scope=1"];
    [self request: httpUrl withHttpArg: httpArg];
    return self.data;
    
}
@end
