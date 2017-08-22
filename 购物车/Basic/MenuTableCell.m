//
//  MenuTableCell.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/12.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "MenuTableCell.h"
#import "Header.h"
@interface MenuTableCell()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation MenuTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 16, 16)];
        numberLabel.backgroundColor = [UIColor redColor];
        numberLabel.layer.cornerRadius = 8;
        numberLabel.layer.masksToBounds = YES;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:13];
        self.numberLabel = numberLabel;
        [self.contentView addSubview:numberLabel];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.2, 100, 0.8)];
        lineView.backgroundColor = RGB_COLOR(220, 220, 220);
        [self.contentView addSubview:lineView];
        
    }
    return self;
}


- (void)setDataModel:(MenuModel *)dataModel{
    //    NSLog(@"dataModel = %@",dataModel.number);
    self.nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.typeName];
    if ([dataModel.number intValue] == 0) {
        self.numberLabel.hidden = YES;
    }else{
        self.numberLabel.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%@",dataModel.number];
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
