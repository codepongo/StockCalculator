//
//  CandlestickView.h
//  StockCalculator
//
//  Created by zuohaitao on 16/10/15.
//  Copyright © 2016年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandlestickView : UIView
@property (nonatomic,assign) CGPoint startPoint; // 线条起点
@property (nonatomic,assign) CGPoint endPoint; // 线条终点
@property (nonatomic,retain) NSMutableArray *points; // 多点连线数组
@property (nonatomic,retain) NSString *color; // 线条颜色
@property (nonatomic,assign) CGFloat lineWidth; // 线条宽度
@property (nonatomic,assign) BOOL isK;// 是否是实体K线 默认是连接线
@property (nonatomic,assign) BOOL isVol;// 是否是画成交量的实体
@end
