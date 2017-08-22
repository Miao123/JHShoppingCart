//
//  BottomShowView.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/18.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BottomShowView.h"
#import "ShopTableCell.h"
#import "Header.h"
#import "EjectShopModel.h"
@interface BottomShowView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *shoppTable;
@property (nonatomic, strong) NSMutableArray *ejectArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomTableView;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int arrCount;
@property (nonatomic, assign) int dataArrCount;
@property (nonatomic, assign) float allPrice;

@end

@implementation BottomShowView


+ (instancetype)initWithFrame:(CGRect)frame andDataArr:(NSMutableArray *)dataArr block:(void (^)(NSDictionary *, int, NSArray *))block{
    
    BottomShowView *botShowView = [[[self class] alloc] initWithFrame:frame];
    botShowView.ejectArr = [NSMutableArray array];
    botShowView.dataArr = [NSMutableArray array];
    [botShowView frame:frame andDataArr:dataArr];
    botShowView.sendStrBlock = block;
    return botShowView;
}


- (void)frame:(CGRect)frame andDataArr:(NSMutableArray *)dataArr{
    _ejectArr = [dataArr mutableCopy];
    for (NSDictionary *dic in _ejectArr) {
        [_dataArr addObject:[EjectShopModel modelWithDict:dic]];
    }
    _dataArrCount = (int)_dataArr.count;
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHight - 60)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.60];
    self.bottomView = bottomView;
    [[UIApplication sharedApplication].keyWindow addSubview:bottomView];
    
    
    //  手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bottomView addGestureRecognizer:tap];
    
    
    UIView *bottomTableView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, screenWidth, frame.size.height)];
    bottomTableView.backgroundColor = [UIColor whiteColor];
    self.bottomTableView = bottomTableView;
    [self addSubview:bottomTableView];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    headView.backgroundColor = RGB_COLOR(235, 235, 235);
    [bottomTableView addSubview:headView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, headView.height)];
    lineView.backgroundColor = [UIColor redColor];
    [headView addSubview:lineView];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + 5, 0, 100, headView.height)];
    textLabel.text = @"购物车";
    textLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:textLabel];
    
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(screenWidth - 130, 0, 120, headView.height);
    [clearBtn setTitle:@"清空购物车" forState:0];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearBtn setImage:[UIImage imageNamed:@"垃圾篓"] forState:0];
    [clearBtn setTitleColor:[UIColor blackColor] forState:0];
    [clearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 90)];
    [clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:clearBtn];
    
    
    UITableView *shoppTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.bottom, screenWidth, frame.size.height - headView.height) style:UITableViewStylePlain];
    shoppTable.delegate = self;
    shoppTable.dataSource = self;
    shoppTable.bounces = NO;
    shoppTable.tableFooterView = [[UIView alloc] init];
    self.shoppTable = shoppTable;
    [bottomTableView addSubview:shoppTable];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomTableView.transform = CGAffineTransformTranslate(self.bottomTableView.transform, 0, -(self.bottomTableView.height));
        _bottomView.height = screenHight - 60 - frame.size.height;
    }];
}


#pragma mark ----- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopTableCell *cell = [ShopTableCell creatCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = _dataArr[indexPath.row];
    
    [cell setSendChangeBlock:^(int number, EjectShopModel *dataModel, int judge) {
        [_ejectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *nameStr = [NSString stringWithFormat:@"%@",obj[@"name"]];
            if ([nameStr isEqualToString:dataModel.name]) {
                [_dataArr removeAllObjects];
                if (judge == 1) {//    加
                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                    [mutableDict setValue:[@(number) stringValue] forKey:@"vantage"];
                    [_ejectArr replaceObjectAtIndex:idx withObject:mutableDict];
                    for (NSDictionary *dict in _ejectArr) {
                        [self.dataArr addObject:[EjectShopModel modelWithDict:dict]];
                    }
                    [_shoppTable reloadData];
                    if (self.sendStrBlock) {
                        self.sendStrBlock(mutableDict, 1, _ejectArr);
                    }
                }else{//    减
                    if (number == 0) {
                        [_ejectArr removeObjectAtIndex:idx];
                        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                        [mutableDict setValue:[@(number) stringValue] forKey:@"vantage"];
                        for (NSDictionary *dict in _ejectArr) {
                            [self.dataArr addObject:[EjectShopModel modelWithDict:dict]];
                        }
                        if (self.sendStrBlock) {
                            self.sendStrBlock(mutableDict, 0, _ejectArr);
                        }
                        _arrCount = (int)_dataArr.count;
                    }else{
                        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                        [mutableDict setValue:[@(number) stringValue] forKey:@"vantage"];
                        [_ejectArr replaceObjectAtIndex:idx withObject:mutableDict];
                        for (NSDictionary *dict in _ejectArr) {
                            [self.dataArr addObject:[EjectShopModel modelWithDict:dict]];
                        }
                        if (self.sendStrBlock) {
                            self.sendStrBlock(mutableDict, 0, _ejectArr);
                        }
                        _arrCount = (int)_dataArr.count;
                    }
                    [_shoppTable reloadData];
                    
                    if (_dataArrCount == _arrCount) {
                        
                    }else{
                        if (_arrCount < 6) {
                            //  底部view坐标变化
                            if (_arrCount == 0) {// 底部购物车数据为空
                                [self closeView];
                                if (self.sendStateBlock) {
                                    self.sendStateBlock(nil, 0);
                                }
                            }else if(number == 0){
                                _count++;
                                [UIView animateWithDuration:0.2 animations:^{
                                    _bottomView.height = screenHight - 60 - (_arrCount * 55 + 35);
                                    self.bottomTableView.y = 55 * _count;
                                    self.bottomTableView.height = _arrCount * 55 + 35;
                                }];
                            }
                        }
                    }
                }
            }
        }];
    }];
    return cell;
}


-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self closeView];
    if (self.sendStateBlock) {
        self.sendStateBlock(nil, 1);
    }
}


- (void)closeView{
    [self.bottomView removeFromSuperview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomTableView.transform = CGAffineTransformTranslate(self.bottomTableView.transform, 0, self.bottomTableView.height + 60);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0 animations:^{
            
            //            self.bottomview.alpha = 0;
            //            [self.bottomview removeFromSuperview];
            self.alpha = 0;
        }];
    }];
}


//  清空购物车
- (void)clearBtnClick:(UIButton *)sender{
    [self closeView];
    if (self.sendStateBlock) {
//        NSLog(@"_ejectArr = %@",_ejectArr);
        self.sendStateBlock(_ejectArr, 0);
    }
    [_ejectArr removeAllObjects];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
