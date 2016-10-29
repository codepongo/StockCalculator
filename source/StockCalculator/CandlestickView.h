//
//  CandlestickView.h
//  StockCalculator
//
//  Created by zuohaitao on 16/10/15.
//  Copyright © 2016年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandlestickView : UIView
@property (nonatomic,retain) NSMutableArray *points; // 多点连线数组
@property (nonatomic, assign)double scale;
@property (nonatomic, assign) double min;
@property (nonatomic, assign) double max;
@property (nonatomic, assign) double height_of_price;
@end
