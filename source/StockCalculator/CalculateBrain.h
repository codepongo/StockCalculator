//
//  CalculateBrain.h
//  StockCalculator
//
//  Created by zuohaitao on 15/10/25.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCalculator-Swift.h"

//@interface Trade:NSObject {
//    float _amount;
//    float _price;
//    NSInteger _quantity;
//}
//@property (nonatomic) float price;
//@property (nonatomic) NSInteger quantity;
//@property (nonatomic, readonly) float amount;
//-(instancetype) initWithPrice:(float)price AndAmount:(float)quantity;
//@end

@interface CalculateBrainOld : NSObject
@property (nonatomic, copy) NSString* code;
@property(nonatomic) BOOL inSZ;
@property (nonatomic, strong) Rate* rate;
@property (nonatomic, strong) Trade* buy;
@property (nonatomic, strong) Trade* sell;
-(void)setCalculateForGainOrLoss:(BOOL)isGainOrLoss;
-(BOOL)calculateForGainOrLoss;
-(float)commissionOfTrade;
-(float)stampOfTrade;
-(float)transferOfTrade;
-(float)taxesAndDutiesOfTrade;
-(float)resultOfTrade;
-(void)reset;
@end
