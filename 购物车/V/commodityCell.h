//
//  commodityCell.h
//  购物车
//
//  Created by 苗建浩 on 2017/5/12.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "commodityModel.h"

@interface commodityCell : BasicTableViewCell
@property (nonatomic, strong) commodityModel *dataModel;
@property (nonatomic, copy) void(^sendIndexBlock)(int number,commodityModel *dataModel,int judge);

@end
