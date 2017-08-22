//
//  HelpJson.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/16.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "HelpJson.h"

@implementation HelpJson

+ (NSMutableDictionary *)jsonWithDictFromFile:(NSString *)fileName andType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *err = nil;
    NSMutableDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err == nil) {// 读取成功
        return dataDic;
    }
    return nil;//   读取失败，返回为nil
}


+ (NSMutableArray *)jsonWithArrFromFile:(NSString *)fileName andType:(NSString *)type{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *err = nil;
    NSMutableArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err == nil) {// 读取成功
        return dataArr;
    }
    return nil; //  读取失败，返回为nil
}

@end
