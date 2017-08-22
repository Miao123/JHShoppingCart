//
//  HelpJson.h
//  购物车
//
//  Created by 苗建浩 on 2017/5/16.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpJson : NSObject

+ (NSMutableDictionary *)jsonWithDictFromFile:(NSString *)fileName andType:(NSString *)type;

+ (NSMutableArray *)jsonWithArrFromFile:(NSString *)fileName andType:(NSString *)type;

@end
