//
//  CandlestickView.m
//  StockCalculator
//
//  Created by zuohaitao on 16/10/15.
//  Copyright © 2016年 zuohaitao. All rights reserved.
//

#import "CandlestickView.h"
#import "colorModel.h"
#import "UIColor+helper.h"

@implementation CandlestickView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.startPoint = self.frame.origin;
    self.endPoint = self.frame.origin;
    self.color = @"#000000";
    self.lineWidth = 1.0f;
    self.isK = YES;
    self.isVol = NO;
    self.lineWidth = 5;
    
    self.points = [[NSMutableArray alloc]initWithCapacity: self.frame.size.width / 5];
    double last_close = self.frame.size.height/2;
    for (NSUInteger i = 0; i < self.frame.size.width / 5; i++) {
        if (i == 0 || i == self.frame.size.width / 5 - 1) {
            continue;
        }
        double close = last_close * (100.00 + arc4random_uniform(40) - 20) / 100;
        double open = last_close * (100.00 + arc4random_uniform(40) - 20) / 100;
        double high = last_close * (100.00 + arc4random_uniform(40) - 20) / 100;
        double low = last_close * (100.00 + arc4random_uniform(40) - 20) / 100;
        if (high < low) {
            double tmp = high;
            high = low;
            low = tmp;
        }
        if (open > high) {
            double tmp = high;
            high = open;
            open = tmp;
        }
        if (close > high) {
            double tmp = high;
            high = close;
            close = tmp;
        }
        if (open < low) {
            double tmp = low;
            low = open;
            open = tmp;
        }
        if (close < low) {
            double tmp = low;
            low = close;
            close = tmp;
        }
        double ma5, ma10, ma20; {
            if (self.points.count < 5) {
                ma5 = close;
                ma10 = close;
                ma20 = close;
            }
            else {
                ma5 = 0;
                for (NSUInteger j = i; j < i - 5; j--) {
                ma5 += [[self.points objectAtIndex:j] floatValue];
                }
                ma5 /= 5;
            }
        }
        //NSLog(@"%f %f %f %f", open, close, high, low);
        [self.points addObject:@{
                           @"date": @(i * 10),
                           @"high": [NSNumber numberWithDouble: high],
                           @"low": [NSNumber numberWithDouble: low],
                           @"open": [NSNumber numberWithDouble: open],
                           @"close": [NSNumber numberWithDouble: close],
                           @"ma5":[NSNumber numberWithDouble: ma5],
                           @"ma10":[NSNumber numberWithDouble: ma10],
                           @"ma25":[NSNumber numberWithDouble: ma20]
                           }];
        last_close = close;
        
    }

}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    {
        
        const CGPoint points[] = {
            CGPointMake(0, 0),
            CGPointMake(self.frame.size.width, 0)
        };
        CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9f, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    {
        
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height/2),
            CGPointMake(self.frame.size.width, self.frame.size.height/2)
        };
        CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9f, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    {
        
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height),
            CGPointMake(self.frame.size.width, self.frame.size.height)
        };
        CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9f, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    if (self.isK) {
        // 画k线
        for (NSDictionary *item in self.points) {
            // 转换坐标
            CGPoint heightPoint,lowPoint,openPoint,closePoint;
            heightPoint.x = [[item objectForKey:@"date"] floatValue];
            heightPoint.y = [[item objectForKey:@"high"] floatValue];
            lowPoint.x = [[item objectForKey:@"date"] floatValue];
            lowPoint.y = [[item objectForKey:@"low"] floatValue];
            openPoint.x = [[item objectForKey:@"date"] floatValue];
            openPoint.y = [[item objectForKey:@"open"] floatValue];
            closePoint.x = [[item objectForKey:@"date"] floatValue];
            closePoint.y = [[item objectForKey:@"close"] floatValue];
            
            //heightPoint = CGPointFromString([item objectAtIndex:0]);
            //lowPoint = CGPointFromString([item objectAtIndex:1]);
            //openPoint = CGPointFromString([item objectAtIndex:2]);
            //closePoint = CGPointFromString([item objectAtIndex:3]);
            [self drawKWithContext:context height:heightPoint Low:lowPoint open:openPoint close:closePoint width:self.lineWidth];
        }
        
    }else{
        // 画连接线
        [self drawLineWithContext:context];
    }
}
#pragma mark 画连接线
-(void)drawLineWithContext:(CGContextRef)context{
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetShouldAntialias(context, YES);
    colorModel *colormodel = [UIColor RGBWithHexString:self.color withAlpha:self.alpha]; // 设置颜色
    CGContextSetRGBStrokeColor(context, (CGFloat)colormodel.R/255.0f, (CGFloat)colormodel.G/255.0f, (CGFloat)colormodel.B/255.0f, self.alpha);
    if (self.startPoint.x==self.endPoint.x && self.endPoint.y==self.startPoint.y) {
        // 定义多个个点 画多点连线
        for (id item in self.points) {
            CGPoint currentPoint = CGPointFromString(item);
            if ((int)currentPoint.y<(int)self.frame.size.height && currentPoint.y>0) {
                if ([self.points indexOfObject:item]==0) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                    continue;
                }
                CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
                CGContextStrokePath(context); //开始画线
                if ([self.points indexOfObject:item]<self.points.count) {
                    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
                }
                
            }
        }
    }else{
        // 定义两个点 画两点连线
        const CGPoint points[] = {self.startPoint,self.endPoint};
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
}

#pragma mark 画一根K线
-(void)drawKWithContext:(CGContextRef)context height:(CGPoint)heightPoint Low:(CGPoint)lowPoint open:(CGPoint)openPoint close:(CGPoint)closePoint width:(CGFloat)width{
    CGContextSetShouldAntialias(context, NO);
    // 首先判断是绿的还是红的，根据开盘价和收盘价的坐标来计算
    BOOL isKong = NO;
    colorModel *colormodel = [UIColor RGBWithHexString:@"#e60000" withAlpha:self.alpha]; // 设置默认红色
    // 如果开盘价坐标在收盘价坐标上方 则为绿色 即空
    if (openPoint.y<closePoint.y) {
        isKong = YES;
        colormodel = [UIColor RGBWithHexString:@"#008800" withAlpha:self.alpha]; // 设置为绿色
    }
    // 设置颜色
    CGContextSetRGBStrokeColor(context, (CGFloat)colormodel.R/255.0f, (CGFloat)colormodel.G/255.0f, (CGFloat)colormodel.B/255.0f, self.alpha);
    // 首先画一个垂直的线包含上影线和下影线
    // 定义两个点 画两点连线
    if (!self.isVol) {
        CGContextSetLineWidth(context, 1); // 上下阴影线的宽度
        if (self.lineWidth<=2) {
            CGContextSetLineWidth(context, 0.5); // 上下阴影线的宽度
        }
        const CGPoint points[] = {heightPoint,lowPoint};
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    // 再画中间的实体
    CGContextSetLineWidth(context, width); // 改变线的宽度
    CGFloat halfWidth = 0;//width/2;
    // 纠正实体的中心点为当前坐标
    openPoint = CGPointMake(openPoint.x-halfWidth, openPoint.y);
    closePoint = CGPointMake(closePoint.x-halfWidth, closePoint.y);
    if (self.isVol) {
        openPoint = CGPointMake(heightPoint.x-halfWidth, heightPoint.y);
        closePoint = CGPointMake(lowPoint.x-halfWidth, lowPoint.y);
    }
    // 开始画实体
    const CGPoint point[] = {openPoint,closePoint};
    CGContextStrokeLineSegments(context, point, 2);  // 绘制线段（默认不绘制端点）
    //CGContextSetLineCap(context, kCGLineCapSquare) ;// 设置线段的端点形状，方形
}



@end
