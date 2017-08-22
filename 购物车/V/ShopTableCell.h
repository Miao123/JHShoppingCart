//
//  ShopTableCell.h
//  购物车
//
//  Created by 苗建浩 on 2017/5/18.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "EjectShopModel.h"

@interface ShopTableCell : BasicTableViewCell
@property (nonatomic, copy) void (^sendChangeBlock)(int number,EjectShopModel *dataModel,int judge);

@property (nonatomic, strong) EjectShopModel *dataModel;

@end
