//
//  RecordDetail.m
//  StockCalculator
//
//  Created by zuohaitao on 15/11/29.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "RecordDetail.h"
#import "public.h"
#import "AppDelegate.h"

@implementation RecordDetail

- (void)share:(id)sender {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* capture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] sendImageToWeChat:capture];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.data[@"code"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem
                                               alloc]
                                              initWithTitle:@"分享"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(share:)];
    self.type.text = self.data[@"type"];
    if ([self.data[@"type"] isEqualToString:@"保本价格"]) {
        self.result.text = @"%.2f 元／股";
    }
    else {
        self.result.text = @"%.2f 元";
        
    }
    self.buyQuantityLayout.hidden = NO;
    self.buyPriceLayout.hidden = NO;
    self.sellQuantityLayout.hidden = NO;
    self.sellPriceLayout.hidden = NO;
    self.transferContainer.hidden = NO;

    NSArray* keys = @[@"buy.price",@"buy.quantity",@"sell.price",@"sell.quantity", @"commission",@"stamp", @"transfer", @"result"];
    for (NSString* k in keys) {
        UILabel* d = (UILabel*)[self valueForKey:k];
        if (self.data[k] != [NSNull null]) {
            d.text = [NSString stringWithFormat:d.text, ((NSNumber*)self.data[k]).floatValue];
        }
        else {
            if ([k isEqual:@"buy.price"]) {
                
                self.buyPriceLayout.hidden = YES;
                self.buyQuantityLayout.hidden = YES;
            }
            
            if ([k isEqual:@"sell.price"]) {
               self.sellPriceLayout.hidden = YES;
                self.sellQuantityLayout.hidden = YES;
            }
            if ([k isEqual:@"transfer"]) {
                self.transferContainer.hidden = YES;
            }
        }
    }
    UIColor* color = UP_COLOR;
    if (((NSNumber*)self.data[@"result"]).floatValue < 0) {
        color = DOWN_COLOR;
    }

    self.sellprice.textColor = color;
    self.sellquantity.textColor = color;
    self.result.textColor = color;
    
    

}

- (void)setValue:(id _Nullable)value
          forKey:(NSString * _Nonnull)key {
    if ([key isEqual:@"buy.price"]) {
        self.buyprice = value;
        return;
    }
    if ([key isEqual:@"buy.quantity"]) {
        self.buyquantity = value;
        return;
    }
    if ([key isEqual:@"sell.price"]) {
        self.sellprice = value;
        return;
    }
    if ([key isEqual:@"sell.quantity"]) {
        self.sellquantity = value;
        return;
    }
    return [super setValue:value forKey:key];
    
}

- (id _Nullable)valueForKey:(NSString * _Nonnull)key {
    if ([key isEqual:@"buy.price"]) {
        return self.buyprice;
    }
    if ([key isEqual:@"buy.quantity"]) {
        return self.buyquantity;
    }
    if ([key isEqual:@"sell.price"]) {
        return self.sellprice;
    }
    if ([key isEqual:@"sell.quantity"]) {
        return self.sellquantity;
    }
    return [super valueForKey:key];
}

@end
