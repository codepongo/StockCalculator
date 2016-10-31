//
//  CandlestickView.m
//  StockCalculator
//
//  Created by zuohaitao on 16/10/15.
//  Copyright © 2016年 zuohaitao. All rights reserved.
//

#import "CandlestickView.h"


@implementation CandlestickView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.price = CGRectMake(0, self.frame.size.height / 10, self.frame.size.width, self.frame.size.height / 2);
    self.vol = CGRectMake(0, self.frame.size.height * 7 / 10, self.frame.size.width, self.frame.size.height * 3 / 10);
    
    self.points = [[NSMutableArray alloc]initWithCapacity: self.frame.size.width / 7];
    double last_close = self.price.size.height / 2;
    for (NSUInteger i = 0; i < self.frame.size.width / 7 - 2; i++) {
        
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
        };
        if (i == 1) {
            self.min = low;
            self.max = high;
        }
        else {
            if (low < self.min) {
                self.min = low;
            }
            if (high > self.max) {
                self.max = high;
            }
        }
        double ma5, ma10, ma20; {
            if (self.points.count < 5) {
                ma5 = close;
                ma10 = open;
                ma20 = low;
            }
            else {
                ma5 = 0;
                for (NSUInteger j = self.points.count - 5; j < self.points.count; j++) {
                    ma5 += [[self.points objectAtIndex:j][@"close"] floatValue];
                }
                ma5 /= 5;
            }
            if (self.points.count < 10) {
                ma10 = open;
                ma20 = low;
            }
            else {
                ma10 = 0;
                for (NSUInteger j = self.points.count - 10; j < self.points.count; j++) {
                    ma10 += [[self.points objectAtIndex:j][@"close"] floatValue];
                }
                ma10 /= 10;
            }
            if (self.points.count < 20) {
                ma20 = close;
            }
            else {
                ma20 = 0;
                for (NSUInteger j = self.points.count - 20; j < self.points.count; j++) {
                    ma20 += [[self.points objectAtIndex:j][@"close"] floatValue];
                }
                ma20 /= 20;
            }
            
        }
        [self.points addObject:@{
                           @"date": @(i * 7 + 3),
                           @"high": [NSNumber numberWithDouble: high],
                           @"low": [NSNumber numberWithDouble: low],
                           @"open": [NSNumber numberWithDouble: open],
                           @"close": [NSNumber numberWithDouble: close],
                           @"ma5":[NSNumber numberWithDouble: ma5],
                           @"ma10":[NSNumber numberWithDouble: ma10],
                           @"ma20":[NSNumber numberWithDouble: ma20]
                           }];
        last_close = close;
        
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    {
        CGContextSetRGBStrokeColor(context, 209/255.00, 209/255.00, 209/255.00, 1);
        CGRect rc = {0, 0, self.frame.size.width, self.frame.size.height};
         CGContextStrokeRect(context, rc);
    }

    
    {
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height / 10),
            CGPointMake(self.frame.size.width, self.frame.size.height / 10)
        };
        CGContextSetRGBStrokeColor(context, 232/255.00, 232/255.00, 232/255.00, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    
    {
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height * 6 / 10),
            CGPointMake(self.frame.size.width, self.frame.size.height * 6 / 10)
        };
        CGContextSetRGBStrokeColor(context, 232/255.00, 232/255.00, 232/255.00, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    

    {
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height * 7 / 10),
            CGPointMake(self.frame.size.width, self.frame.size.height * 7 / 10)
        };
        CGContextSetRGBStrokeColor(context, 232/255.00, 232/255.00, 232/255.00, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
    
    {
        const CGPoint points[] = {
            CGPointMake(self.frame.size.width / 3, 0),
            CGPointMake(self.frame.size.width / 3, self.frame.size.height)
        };
        CGContextSetRGBStrokeColor(context, 244/255.00, 244/255.00, 244/255.00, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }

    {
        const CGPoint points[] = {
            CGPointMake(self.frame.size.width * 2 / 3, 0),
            CGPointMake(self.frame.size.width * 2 / 3, self.frame.size.height)
        };
        CGContextSetRGBStrokeColor(context, 244/255.00, 244/255.00, 244/255.00, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
     /*
    {
        
        const CGPoint points[] = {
            CGPointMake(0, self.frame.size.height),
            CGPointMake(self.frame.size.width, self.frame.size.height)
        };
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0f, 1);
        CGContextStrokeLineSegments(context, points, 2);  // 绘制线段（默认不绘制端点）
    }
     */
    
    for (NSDictionary *item in self.points) {
        // 转换坐标
        CGPoint heightPoint,lowPoint,openPoint,closePoint;
        heightPoint.x = [[item objectForKey:@"date"] floatValue];
        heightPoint.y = (1 - ([[item objectForKey:@"high"] floatValue] - self.min) / (self.max - self.min)) * self.price.size.height + self.price.origin.y;
        lowPoint.x = [[item objectForKey:@"date"] floatValue];
        lowPoint.y = (1 - ([[item objectForKey:@"low"] floatValue] - self.min) / (self.max - self.min)) * self.price.size.height + self.price.origin.y;
        openPoint.x = [[item objectForKey:@"date"] floatValue];
        openPoint.y = (1 - ([[item objectForKey:@"open"] floatValue] - self.min) / (self.max - self.min)) * self.price.size.height + self.price.origin.y;
        closePoint.x = [[item objectForKey:@"date"] floatValue];
        closePoint.y = (1 - ([[item objectForKey:@"close"] floatValue] - self.min) / (self.max - self.min)) * self.price.size.height + self.price.origin.y;
        
        UIColor *clr = [UIColor colorWithRed:198/255.00 green:49/255.00 blue:40/255.00 alpha:1];
        if (openPoint.y<closePoint.y) {
            clr = [UIColor colorWithRed:37/255.00 green:149/255.00 blue:76/255.00 alpha:1];
        }

        [self drawKWithContext:context height:heightPoint Low:lowPoint open:openPoint close:closePoint width:5 color:clr];
        CGFloat y = ([[item objectForKey:@"open"] floatValue] - self.min) / (self.max - self.min) * self.vol.size.height + self.vol.origin.y;
        [self drawVolWithContext:context end:CGPointMake([[item objectForKey:@"date"] floatValue], y) width:5 color:clr];
    }
    
    
    // 画连接线
    [self draw:@"ma5" In:[UIColor colorWithRed:252.00/255 green:201.00/255 blue:22.00/255 alpha:1.0] WithContext:context];
    [self draw:@"ma10" In:[UIColor colorWithRed:44.00/255 green:123.00/255 blue:246.00/255 alpha:1.0] WithContext:context];
    [self draw:@"ma20" In:[UIColor colorWithRed:202.00/255 green:17.00/255 blue:240.00/255 alpha:1.0] WithContext:context];
    {
        NSString* max = [NSString stringWithFormat:@"%.2f", self.max];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:106/255.00 green:106/255.00 blue:106/255.00 alpha:1.0], NSForegroundColorAttributeName, nil];
        CGSize size = [max sizeWithAttributes:attributes];
        [max drawAtPoint:CGPointMake(self.frame.size.width - size.width -1, self.frame.size.height / 20) withAttributes:attributes];
    }
    
    {
        NSString* min = [NSString stringWithFormat:@"%.2f", self.min];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:106/255.00 green:106/255.00 blue:106/255.00 alpha:1.0], NSForegroundColorAttributeName, nil];
        CGSize size = [min sizeWithAttributes:attributes];
        [min drawAtPoint:CGPointMake(self.frame.size.width - size.width - 1, self.frame.size.height * 11 / 20) withAttributes:attributes];
    }

    

}
#pragma mark 画连接线
-(void)draw:(NSString*)line In:(UIColor*) color WithContext:(CGContextRef)context{
    CGContextSetLineWidth(context, 1);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetStrokeColor(context, CGColorGetComponents(color.CGColor));
   
    // 定义多个个点 画多点连线
    for (id item in self.points) {
        CGPoint p;
        p.x = [[item objectForKey:@"date"] floatValue];
        p.y = (1 - ([[item objectForKey:line] floatValue] - self.min) / (self.max - self.min)) * self.price.size.height + self.price.origin.y;
        if ([self.points indexOfObject:item]==0) {
            CGContextMoveToPoint(context, p.x, p.y);
            continue;
        }
        CGContextAddLineToPoint(context, p.x, p.y);
        CGContextStrokePath(context); //开始画线
        if ([self.points indexOfObject:item]<self.points.count) {
            CGContextMoveToPoint(context, p.x, p.y);
        }
    }

}

#pragma mark 画一根K线
-(void)drawKWithContext:(CGContextRef)context height:(CGPoint)heightPoint Low:(CGPoint)lowPoint open:(CGPoint)openPoint close:(CGPoint)closePoint width:(CGFloat)width color:(UIColor*) color {
    CGContextSetShouldAntialias(context, NO);

    CGContextSetStrokeColor(context, CGColorGetComponents(color.CGColor));

    CGContextSetLineWidth(context, 1);
    const CGPoint points[] = {heightPoint,lowPoint};
    CGContextStrokeLineSegments(context, points, 2);
    
    CGContextSetLineWidth(context, width);
    const CGPoint point[] = {openPoint,closePoint};
    CGContextStrokeLineSegments(context, point, 2);
}

#pragma mark 画成交量
-(void)drawVolWithContext:(CGContextRef)context end:(CGPoint)end width:(CGFloat)width color:(UIColor*)color{
    CGContextSetShouldAntialias(context, NO);
    
    CGContextSetStrokeColor(context, CGColorGetComponents(color.CGColor));
    
    CGContextSetLineWidth(context, 1);
    const CGPoint points[] = {end, CGPointMake(end.x, self.frame.size.height)};
    CGContextSetLineWidth(context, width);
    CGContextStrokeLineSegments(context, points, 2);
}


@end
