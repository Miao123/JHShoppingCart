//
//  commodityCell.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/12.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "commodityCell.h"
#import "Header.h"
@interface commodityCell()
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) int number;


@end

@implementation commodityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _number = 0;
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 68, 68)];
        self.headImage = headImage;
        [self.contentView addSubview:headImage];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 8, 12, screenWidth - 100 - 20, 18)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
        UILabel *stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5, 120, 15)];
        stockLabel.font = [UIFont systemFontOfSize:13];
        stockLabel.textColor = RGB_COLOR(150, 150, 150);
        self.stockLabel = stockLabel;
        [self.contentView addSubview:stockLabel];
        
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, stockLabel.bottom + 5, 100, 15)];
        priceLabel.font = [UIFont systemFontOfSize:13];
        priceLabel.textColor = [UIColor redColor];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(screenWidth - 100 - 38, 35, 40, 40);
        [addBtn setImage:[UIImage imageNamed:@"加"] forState:0];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.addBtn = addBtn;
        [self.contentView addSubview:addBtn];
        
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(addBtn.left - 20, addBtn.top, 35, 40)];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel = numberLabel;
        [self.contentView addSubview:numberLabel];
        
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.frame = CGRectMake(numberLabel.left - 25, addBtn.top , 40, 40);
        [reduceBtn setImage:[UIImage imageNamed:@"减"] forState:0];
        [reduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.reduceBtn = reduceBtn;
        [self.contentView addSubview:reduceBtn];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79.2, screenWidth - 100, 0.8)];
        lineView.backgroundColor = RGB_COLOR(220, 220, 220);
        self.lineView = lineView;
        [self.contentView addSubview:lineView];
    }
    return self;
}


//  加
- (void)addBtnClick:(UIButton *)sender{
    _number = [_dataModel.vantage intValue] + 1;
    if (self.sendIndexBlock) {
        self.sendIndexBlock(_number,_dataModel,1);
    }
}


//  减
- (void)reduceBtnClick:(UIButton *)sender{
    _number = [_dataModel.vantage intValue] - 1;
    if (self.sendIndexBlock) {
        self.sendIndexBlock(_number,_dataModel,0);
    }
}


- (void)setDataModel:(commodityModel *)dataModel{
    _dataModel = dataModel;
    //    http://in.ganinfo.com/files/img/
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://in.ganinfo.com/files/img/%@",dataModel.images]] placeholderImage:[UIImage imageNamed:@"111"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.name];
    _stockLabel.text = [NSString stringWithFormat:@"库存:%@",dataModel.stock];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@/1kg",dataModel.price];
    if ([dataModel.vantage intValue] == 0) {
        _numberLabel.hidden = YES;
        _reduceBtn.hidden = YES;
        
    }else{
        _numberLabel.hidden = NO;
        _reduceBtn.hidden = NO;
        _numberLabel.text = [NSString stringWithFormat:@"%@",dataModel.vantage];
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
