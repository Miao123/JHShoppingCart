//
//  MenuTableCell.h
//  购物车
//
//  Created by 苗建浩 on 2017/5/12.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "MenuModel.h"

@interface MenuTableCell : BasicTableViewCell
@property (nonatomic, strong) MenuModel *dataModel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end
