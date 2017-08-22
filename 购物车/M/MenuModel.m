//
//  MenuModel.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/15.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"typename"]){
        self.typeName = value;
    }
}


@end
