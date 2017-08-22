//
//  BottomShowView.h
//  购物车
//
//  Created by 苗建浩 on 2017/5/18.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomShowView : UIView

@property (nonatomic, copy) void(^sendStrBlock)(NSDictionary *, int, NSArray *);

@property (nonatomic, copy) void(^sendStateBlock)(NSArray *, int);

+ (instancetype)initWithFrame:(CGRect)frame andDataArr:(NSMutableArray *)dataArr block:(void(^)(NSDictionary *, int, NSArray*))block;

- (void)frame:(CGRect)frame andDataArr:(NSMutableArray *)dataArr;

- (void)closeView;

@end
