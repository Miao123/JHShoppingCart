//
//  ShopTableCell.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/18.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ShopTableCell.h"
#import "Header.h"
@interface ShopTableCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) int number;

@end

@implementation ShopTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 55)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 150, 0, 60, 55)];
        priceLabel.font = [UIFont systemFontOfSize:16];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(screenWidth - 43, 15 / 2, 40, 40);
        [addBtn setImage:[UIImage imageNamed:@"加"] forState:0];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.addBtn = addBtn;
        [self.contentView addSubview:addBtn];
        
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(addBtn.left - 25, addBtn.top, 35, 40)];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel = numberLabel;
        [self.contentView addSubview:numberLabel];
        
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.frame = CGRectMake(numberLabel.left - 30, addBtn.top , 40, 40);
        [reduceBtn setImage:[UIImage imageNamed:@"减"] forState:0];
        [reduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.reduceBtn = reduceBtn;
        [self.contentView addSubview:reduceBtn];
    }
    return self;
}


- (void)setDataModel:(EjectShopModel *)dataModel{
    _dataModel = dataModel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",([dataModel.vantage intValue] * [dataModel.price floatValue])];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",dataModel.vantage];
}


//  加
- (void)addBtnClick:(UIButton *)sender{
    _number = [_dataModel.vantage intValue] + 1;
    if (self.sendChangeBlock) {
        self.sendChangeBlock(_number,_dataModel,1);
    }
}


//  减
- (void)reduceBtnClick:(UIButton *)sender{
    _number = [_dataModel.vantage intValue] - 1;
    if (self.sendChangeBlock) {
        self.sendChangeBlock(_number,_dataModel,0);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
