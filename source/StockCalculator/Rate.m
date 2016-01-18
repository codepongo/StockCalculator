//
//  Rate.m
//  StockCalculator
//
//  Created by zuohaitao on 15/10/28.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "Rate.h"

@implementation RateOld

-(instancetype)init{
    self = [super init];
    return self;
}

-(float)commission {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"commission"];
}


-(float) stamp {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"stamp"];
}


-(float)transfer {
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"transfer"];
}

-(void)setCommission:(float)c {
    [[NSUserDefaults standardUserDefaults] setFloat:c forKey:@"commission"];
}

-(void)setStamp:(float)s {
    [[NSUserDefaults standardUserDefaults] setFloat:s forKey:@"stamp"];
}

-(void)setTransfer:(float)t {
    [[NSUserDefaults standardUserDefaults] setFloat:t forKey:@"transfer"];
}



@end