//
//  ViewController.m
//  购物车
//
//  Created by 苗建浩 on 2017/5/12.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "ViewController.h"
#import "MenuTableCell.h"
#import "MenuModel.h"
#import "commodityCell.h"
#import "commodityModel.h"
#import "BottomShowView.h"
#import "Header.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) NSMutableArray *menuArr;
@property (nonatomic, strong) NSMutableArray *menuDataArr;
@property (nonatomic, strong) UITableView *commodityTable;
@property (nonatomic, strong) NSMutableArray *commDataArr;
@property (nonatomic, strong) NSMutableArray *commodityArr;
@property (nonatomic, strong) NSMutableArray *botShoppArr;//    底部弹出购物车的数据源
@property (nonatomic, strong) UIScrollView *commodityScroll;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *shoppBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) BottomShowView *showView;
@property (nonatomic, strong) UILabel *allPriceLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) NSMutableArray *ejectDataArr;
@property (nonatomic, assign) int leftIndex;
@property (nonatomic, assign) int leftCount;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int totalNumber;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, assign) BOOL clickBOOL;
@property (nonatomic, copy) NSString *numberID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.menuDataArr = [NSMutableArray array];
    self.commDataArr = [NSMutableArray array];
    self.botShoppArr = [NSMutableArray array];
    self.ejectDataArr = [NSMutableArray array];
    _leftCount = 0;
    _leftIndex = 0;
    _totalNumber = 0;
    _totalPrice = 0.0;
    _clickBOOL = YES;
    
    
    NSMutableDictionary *dataDic = [HelpJson jsonWithDictFromFile:@"dataJson" andType:@"json"];
    _menuArr = dataDic[@"data"];
    _numberID = [NSString stringWithFormat:@"%@",_menuArr[0][@"id"]];
    for (NSDictionary *dict in _menuArr) {
        [dict setValue:@"0" forKey:@"number"];
        [self.menuDataArr addObject:[MenuModel modelWithDict:dict]];
    }
    
    
    _commodityArr = _menuArr[0][@"goodslist"];
    for (NSDictionary *dict in _commodityArr) {
        [self.commDataArr addObject:[commodityModel modelWithDict:dict]];
    }
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHight - 80, screenWidth, 80)];
    bottomView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:bottomView];
    
    
    UITableView *menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVGATION_ADD_STATUS_HEIGHT, 100, screenHight - NAVGATION_ADD_STATUS_HEIGHT - 60) style:UITableViewStylePlain];
    menuTable.delegate = self;
    menuTable.dataSource = self;
    menuTable.tableFooterView = [[UIView alloc] init];
    menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTable = menuTable;
    [self.view addSubview:menuTable];
    
    
    UITableView *commodityTable = [[UITableView alloc] initWithFrame:CGRectMake(100, NAVGATION_ADD_STATUS_HEIGHT, screenWidth - 100, screenHight - NAVGATION_ADD_STATUS_HEIGHT - 60) style:UITableViewStylePlain];
    commodityTable.delegate = self;
    commodityTable.dataSource = self;
    commodityTable.tableFooterView = [[UIView alloc] init];
    commodityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commodityTable = commodityTable;
    [self.view addSubview:commodityTable];
    
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 60)];
    showView.backgroundColor = RGB_COLOR(50, 50, 50);
    [bottomView addSubview:showView];
    
    
    UIButton *shoppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppBtn.frame = CGRectMake(10, 0, 50, showView.height);
    shoppBtn.backgroundColor = [UIColor redColor];
    [shoppBtn addTarget:self action:@selector(shoppBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shoppBtn = shoppBtn;
    [showView addSubview:shoppBtn];
    
    
    UILabel *allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, showView.height)];
    allPriceLabel.text = @"合计:¥0.0";
    allPriceLabel.font = [UIFont systemFontOfSize:17];
    allPriceLabel.textColor = [UIColor whiteColor];
    self.allPriceLabel = allPriceLabel;
    [showView addSubview:allPriceLabel];
    
    
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 120, 0, 120, showView.height)];
    sendLabel.backgroundColor = RGB_COLOR(75, 75, 75);
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.font = [UIFont systemFontOfSize:16];
    sendLabel.text = @"¥20起送";
    sendLabel.textColor = [UIColor lightGrayColor];
    self.sendLabel = sendLabel;
    [showView addSubview:sendLabel];
    
    
    UIScrollView *commodityScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHight)];
    commodityScroll.contentSize = CGSizeMake(_commDataArr.count * screenWidth, screenHight);
    commodityScroll.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.30];
    commodityScroll.pagingEnabled = YES;
    commodityScroll.delegate = self;
    commodityScroll.bounces = NO;
    commodityScroll.showsHorizontalScrollIndicator = NO;
    self.commodityScroll = commodityScroll;
    //    [[UIApplication sharedApplication].keyWindow addSubview:commodityScroll];
    
    
    //  手势
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [commodityScroll addGestureRecognizer:tap];
    
    [self imageShow];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, screenHight - 80, 45, 45);
    closeBtn.centerX = [UIApplication sharedApplication].keyWindow.centerX;
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:0];
    closeBtn.hidden = YES;
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = closeBtn;
    //    [[UIApplication sharedApplication].keyWindow addSubview:closeBtn];
    
}


- (void)imageShow{
    for (int i = 0; i < _commDataArr.count; i++) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(50 + screenWidth * i, 100, screenWidth - 100, screenHight / 1.5)];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.cornerRadius = 5;
        bottomView.layer.masksToBounds = YES;
        [_commodityScroll addSubview:bottomView];
        
        
        commodityModel *dataModel = _commDataArr[i];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, 50)];
        nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.name];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont boldSystemFontOfSize:17];
        [bottomView addSubview:nameLabel];
        
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, nameLabel.bottom, bottomView.width - 10, bottomView.width - 30)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://in.ganinfo.com/files/img/%@",dataModel.images]] placeholderImage:[UIImage imageNamed:@"111"]];
        headImage.layer.cornerRadius = 5;
        headImage.layer.masksToBounds = YES;
        [bottomView addSubview:headImage];
        
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, headImage.bottom + 5, 0, 30)];
        priceLabel.text = [NSString stringWithFormat:@"¥%@",dataModel.price];
        [priceLabel sizeToFit];
        priceLabel.textColor = [UIColor redColor];
        [bottomView addSubview:priceLabel];
        
        
        UILabel *opriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.right + 8, priceLabel.top, 0, 30)];
        opriceLabel.text = [NSString stringWithFormat:@"%@",dataModel.oprice];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",dataModel.oprice] attributes:attribtDic];
        [opriceLabel sizeToFit];
        // 赋值
        opriceLabel.attributedText = attribtStr;
        [bottomView addSubview:opriceLabel];
        
        
        UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(10, priceLabel.bottom + 5, bottomView.width - 20, 30)];
        textLable.text = @"没什么好介绍的";
        [bottomView addSubview:textLable];
    }
}


#pragma mark ------- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _menuTable) return _menuDataArr.count;
    if (tableView == _commodityTable) return _commDataArr.count;
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTable) return 50;
    if (tableView == _commodityTable) return 80;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTable) {
        MenuTableCell *cell = [MenuTableCell creatCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == _leftIndex) {
            cell.nameLabel.textColor = [UIColor redColor];
        }else{
            cell.nameLabel.textColor = [UIColor blackColor];
        }
        cell.dataModel = _menuDataArr[indexPath.row];
        cell.contentView.backgroundColor = RGB_COLOR(240, 240, 240);
        return cell;
    }else{
        commodityCell *cell = [commodityCell creatCellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.dataModel = _commDataArr[indexPath.row];
        [cell setSendIndexBlock:^(int number,commodityModel *dataModel,int judge) {
            [self.commDataArr removeAllObjects];
            [self.menuDataArr removeAllObjects];
            
            [_menuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *number = [NSString stringWithFormat:@"%@",obj[@"id"]];
                if ([_numberID isEqualToString:number]) {
                    if (judge == 1) {
                        _leftCount++;
                        _totalNumber++;
                    }else{
                        _leftCount--;
                        _totalNumber--;
                    }
                    if (_totalNumber == 0) {
                        self.shoppBtn.hidden = YES;
                    }else{
                        self.shoppBtn.hidden = NO;
                        [self.shoppBtn setTitle:[NSString stringWithFormat:@"%d",_totalNumber] forState:0];
                    }
                    
                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                    [mutableDict setValue:[@(_leftCount) stringValue] forKey:@"number"];
                    [_menuArr replaceObjectAtIndex:_leftIndex withObject:mutableDict];
                    for (NSDictionary *dict in _menuArr) {
                        [self.menuDataArr addObject:[MenuModel modelWithDict:dict]];
                    }
                    [_menuTable reloadData];
                }
            }];
            
            
            [_commodityArr enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
                NSString *nameStr = [NSString stringWithFormat:@"%@",obj[@"name"]];
                if ([nameStr isEqualToString:dataModel.name]) {
                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                    [mutableDict setValue:[@(number) stringValue] forKey:@"vantage"];
                    [_commodityArr replaceObjectAtIndex:indexPath.row withObject:mutableDict];
                    for (NSDictionary *dict in _commodityArr) {
                        [self.commDataArr addObject:[commodityModel modelWithDict:dict]];
                    }
                    [_commodityTable reloadData];
                    
                    if (judge == 1) {//     加
                        _totalPrice = _totalPrice + [dataModel.price doubleValue];
                        _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%g",_totalPrice];
                        if (_totalPrice >= 20.0) {
                            _sendLabel.text = @"去结算";
                            _sendLabel.font = [UIFont boldSystemFontOfSize:17];
                            _sendLabel.textColor = [UIColor whiteColor];
                            _sendLabel.backgroundColor = [UIColor redColor];
                        }else{
                            float price = 20 - _totalPrice;
                            _sendLabel.textColor = [UIColor lightGrayColor];
                            _sendLabel.backgroundColor = RGB_COLOR(75, 75, 75);
                            _sendLabel.text = [NSString stringWithFormat:@"差%g起送",price];
                        }
                        
                        
                        //  底部购物车详情数据
                        [_ejectDataArr addObject:mutableDict];
                        [_ejectDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSString *name = [NSString stringWithFormat:@"%@",mutableDict[@"name"]];
                            NSString *objName = [NSString stringWithFormat:@"%@",obj[@"name"]];
                            if ([name isEqualToString:objName]) {
                                [_ejectDataArr removeObjectAtIndex:idx];
                            }
                            if (idx == 0) {
                                [_ejectDataArr addObject:mutableDict];
                            }
                        }];
                        _clickBOOL = YES;
                    }else{//    减
                        _totalPrice = _totalPrice - [dataModel.price doubleValue];
                        if (_totalPrice >= 20.0) {
                            _sendLabel.text = @"去结算";
                            _sendLabel.font = [UIFont boldSystemFontOfSize:17];
                            _sendLabel.textColor = [UIColor whiteColor];
                            _sendLabel.backgroundColor = [UIColor redColor];
                            _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%g",_totalPrice];
                            
                        }else{
                            float price = 20 - _totalPrice;
                            if (price == 20) {
                                _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥0"];
                            }else{
                                _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%g",_totalPrice];
                            }
                            _sendLabel.backgroundColor = RGB_COLOR(75, 75, 75);
                            _sendLabel.textColor = [UIColor lightGrayColor];
                            _sendLabel.text = [NSString stringWithFormat:@"差%g起送",price];
                        }
                        
                        if (number == 0) {
                            [_ejectDataArr removeObject:obj];// 删除对应的数据
                        }else{
                            //  底部购物车详情数据
                            [_ejectDataArr addObject:mutableDict];
                            [_ejectDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString *name = [NSString stringWithFormat:@"%@",mutableDict[@"name"]];
                                NSString *objName = [NSString stringWithFormat:@"%@",obj[@"name"]];
                                if ([name isEqualToString:objName]) {
                                    [_ejectDataArr removeObjectAtIndex:idx];
                                }
                                if (idx == 0) {
                                    [_ejectDataArr addObject:mutableDict];
                                }
                            }];
                            _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%g",_totalPrice];
                        }
                    }
                }
            }];
        }];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTable) {
        _leftIndex = (int)indexPath.row;
        _leftCount = [[NSString stringWithFormat:@"%@",_menuArr[indexPath.row][@"number"]] intValue];
        _numberID = [NSString stringWithFormat:@"%@",_menuArr[indexPath.row][@"id"]];
        [_menuTable reloadData];
        
        [_commDataArr removeAllObjects];
        _commodityArr = _menuArr[indexPath.row][@"goodslist"];
        for (NSDictionary *dict in _commodityArr) {
            [self.commDataArr addObject:[commodityModel modelWithDict:dict]];
        }
        _commodityScroll.contentSize = CGSizeMake(_commDataArr.count * screenWidth, screenHight);
        [self imageShow];
        [_commodityTable reloadData];
        
    }else{
        [_menuTable reloadData];
        _number = (int)indexPath.row;
        self.commodityScroll.contentOffset = CGPointMake(screenWidth * _number, 0);
        [[UIApplication sharedApplication].keyWindow addSubview:_commodityScroll];
        [[UIApplication sharedApplication].keyWindow addSubview:_closeBtn];
        
        _closeBtn.hidden = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    _number = offSetX / screenWidth;
}


- (void)shoppBtnClick:(UIButton *)sender{
    if (_ejectDataArr.count > 0) {//    弹出详情数组有值的情况下
        if (_clickBOOL) {
            CGFloat height = 0;
            if (_ejectDataArr.count >= 6) {
                height = 6 * 55 + 35;
            }else{
                height = _ejectDataArr.count * 55 + 35;
            }
            
            BottomShowView *showView = [BottomShowView initWithFrame:CGRectMake(0, screenHight - 60 - height, screenWidth, height) andDataArr:_ejectDataArr block:^(NSDictionary *sendDic, int judge, NSArray *sendArr) {
                
                [self.commDataArr removeAllObjects];
                _ejectDataArr = [sendArr mutableCopy];
                //                                [_menuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                                    NSArray *dataArr = obj[@"goodslist"];
                //                                    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //                                        NSString *nameStr = [NSString stringWithFormat:@"%@",sendDic[@"name"]];
                //                                        NSString *objName = [NSString stringWithFormat:@"%@",obj[@"name"]];
                //                                        if ([nameStr isEqualToString:objName]) {
                //                                            _commodityArr = [dataArr mutableCopy];
                //                                            [_menuTable reloadData];
                //                                        }
                //                                    }];
                //                                }];
                
                
                [_commodityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *nameStr = [NSString stringWithFormat:@"%@",sendDic[@"name"]];
                    NSString *objName = [NSString stringWithFormat:@"%@",obj[@"name"]];
                    if ([nameStr isEqualToString:objName]) {
                        if (judge == 1) {//     加
                            _totalPrice = _totalPrice + [obj[@"price"] doubleValue];
                            _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥%g",_totalPrice];
                            if (_totalPrice >= 20.0) {
                                [self goClearing];//    去结算
                            }else{
                                float price = 20 - _totalPrice;
                                _sendLabel.textColor = [UIColor lightGrayColor];
                                _sendLabel.backgroundColor = RGB_COLOR(75, 75, 75);
                                _sendLabel.text = [NSString stringWithFormat:@"差%g起送",price];
                            }
                            _totalNumber++;
                            [self.shoppBtn setTitle:[NSString stringWithFormat:@"%d",_totalNumber] forState:0];
                            
                        }else if (judge == 0){//    减
                            _totalPrice = _totalPrice - [obj[@"price"] doubleValue];
                            _allPriceLabel.text = [NSString stringWithFormat:@"合计%g",_totalPrice];
                            
                            if (_totalPrice >= 20.0) {
                                [self goClearing];//  去结算
                            }else{
                                if (_totalPrice == 0) {
                                    _allPriceLabel.text = [NSString stringWithFormat:@"合计:¥0.0"];
                                }else{
                                    double price = 20 - _totalPrice;
                                    _sendLabel.textColor = [UIColor lightGrayColor];
                                    _sendLabel.backgroundColor = RGB_COLOR(75, 75, 75);
                                    _sendLabel.text = [NSString stringWithFormat:@"差%0.2f起送",price];
                                }
                            }
                            _totalNumber--;
                            [self.shoppBtn setTitle:[NSString stringWithFormat:@"%d",_totalNumber] forState:0];
                        }
                        [_commodityArr replaceObjectAtIndex:idx withObject:sendDic];
                        for (NSDictionary *dict in _commodityArr) {
                            [self.commDataArr addObject:[commodityModel modelWithDict:dict]];
                        }
                        [_commodityTable reloadData];
                    }
                }];
            }];
            
            
            //  清空购物车方法
            [showView setSendStateBlock:^(NSArray *dataArr, int state) {
                _clickBOOL = state;
                if (state == 0) {// 清空购物车
                    if (dataArr.count > 0) {
                        for (NSDictionary *dic in dataArr) {
                            [_commDataArr removeAllObjects];
                            NSString *backNameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
                            NSArray *goodsArr = _menuArr[_leftIndex][@"goodslist"];
                            [goodsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString *nameStr = obj[@"name"];
                                if ([backNameStr isEqualToString:nameStr]) {
                                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                                    [mutableDict setValue:@"0" forKey:@"vantage"];
                                    [_commodityArr replaceObjectAtIndex:idx withObject:mutableDict];
                                    for (NSDictionary *dict in _commodityArr) {
                                        [self.commDataArr addObject:[commodityModel modelWithDict:dict]];
                                    }
                                    NSLog(@"走了几次这个方法 %@",mutableDict);
                                    [_commodityTable reloadData];
                                }
                            }];
                        }
                        for (NSMutableDictionary *dict in _menuArr) {
                            dict[@"number"] = @"0";
                            [self.menuDataArr addObject:[MenuModel modelWithDict:dict]];
                        }
                        for (MenuModel *model in _menuDataArr) {
                            model.number = @"0";
                        }
                        [_menuTable reloadData];
                    }
                    [self.ejectDataArr removeAllObjects];
                    _allPriceLabel.text = @"合计:¥0.0";
                    _sendLabel.text = [NSString stringWithFormat:@"¥20起送"];
                    [self.shoppBtn setTitle:[NSString stringWithFormat:@""] forState:0];
                    _totalNumber = 0;
                    _leftCount = 0;
                    _totalPrice = 0;
                }
            }];
            self.showView = showView;
            [self.view addSubview:showView];
        }else{
            [self.showView closeView];
        }
        _clickBOOL = !_clickBOOL;
    }
}


-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [self close];
}


- (void)closeBtnClick:(UIButton *)sender{
    [self close];
}


- (void)close{
    _closeBtn.hidden = YES;
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_number inSection:0];
    [[self commodityTable] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.commodityScroll removeFromSuperview];
    }];
}


//  去结算
- (void)goClearing{
    _sendLabel.text = @"去结算";
    _sendLabel.font = [UIFont boldSystemFontOfSize:17];
    _sendLabel.textColor = [UIColor whiteColor];
    _sendLabel.backgroundColor = [UIColor redColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
