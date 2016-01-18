//
//  CalculateBrain.m
//  StockCalculator
//
//  Created by zuohaitao on 15/10/25.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "CalculateBrain.h"
#import <Foundation/NSUserDefaults.h>

#pragma mark -
#pragma mark CalculateBrain

@interface CalculateBrainOld()
-(float)commission:(float)amount;
-(float)stamp:(float)amount;
-(float)transfer:(float)quantity;
@end

@implementation CalculateBrainOld

- (instancetype) init {
    self = [super init];
    self.inSZ = NO;
    self.calculateForGainOrLoss = YES;
    self.rate = [[Rate alloc]init];
    self.buy = [[Trade alloc] init];
    return self;
}

- (void)setCalculateForGainOrLoss:(BOOL)isGainOrLess {
    if (isGainOrLess == (self.sell != nil)) {
        return;
    }
    if (isGainOrLess) {
        self.sell = [[Trade alloc] init];
    }
    else {
        self.sell = nil;
    }
}

-(BOOL)calculateForGainOrLoss {
    return self.sell != nil;
}


- (float) commission:(float)amount {
    if (amount - 0.000 <= 0.0001)
    {
        return 0.000;
    }
    if (amount < 10000.000) {
        return 5.000;
    }

    return (amount * [[self.rate valueForKey:@"commission"] floatValue]/ 1000);

}

-(float)stamp:(float)amount {
    if (amount == 0) {
        return 0.000;
    }
    if (amount < 1000) {
        return 1.000;
    }
    return amount * self.rate.stamp / 1000;
}

-(float)transfer:(float)quantity {
    if (self.inSZ) {
        return 0;
    }
    int transfer = (int)quantity % 1000 == 0 ? 0:1;
    transfer +=  ((int)quantity / 1000) * self.rate.transfer;
    return transfer;
}

-(float)commissionOfTrade {
    if (!self.calculateForGainOrLoss) {
        return [self commission:self.buy.amount];
    }
    return  [self commission:self.buy.amount] + [self commission:self.sell.amount];
}

-(float)stampOfTrade {
    if (!self.calculateForGainOrLoss) {
        return [self stamp:self.buy.amount];
    }
    return [self stamp:self.sell.amount];
}

-(float)transferOfTrade {
    if (!self.calculateForGainOrLoss) {
        return [self transfer:self.buy.quantity];
    }
    return [self transfer:self.buy.quantity] + [self transfer:self.buy.quantity];
}

-(float)taxesAndDutiesOfTrade {
    return [self commissionOfTrade] + [self stampOfTrade] + [self transferOfTrade];
}

-(float)resultOfTrade {
    float cost = self.buy.amount + [self taxesAndDutiesOfTrade];
    float income = self.sell.amount;
    if (!self.calculateForGainOrLoss) {
       if (self.buy.quantity == 0) {
           return 0;
       }
       return cost / self.buy.quantity;
    }
    if (self.sell.quantity == 0) {
        return 0;
    }
    return (income - cost);
}

-(void)reset {
    self.buy.price = 0;
    self.buy.quantity = 0;
    if (self.sell != nil) {
        self.sell.price = 0;
        self.sell.quantity = 0;
    }
    self.code = @"";
}
@end
