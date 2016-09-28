//
//  main.m
//  CalculatorTester
//
//  Created by zuohaitao on 20/9/2016.
//  Copyright © 2016 zuohaitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorTester-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CalculateBrain* brain = [[CalculateBrain alloc]init];
        [brain.rate setValue:[NSNumber numberWithDouble:0.31] forKey:@"commission"];
        [brain.rate setValue:[NSNumber numberWithDouble:1] forKey:@"stamp"];
        [brain.rate setValue:[NSNumber numberWithDouble:0.02] forKey:@"transfer"];

        NSError* err;
        NSString* folder = [@"~/Documents/trade" stringByExpandingTildeInPath];
        if (argv[1] != NULL) {
            folder = [[NSString alloc] initWithUTF8String:argv[1]];
        }
        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&err];
        NSMutableArray* record = [NSMutableArray arrayWithCapacity:[files count] * 10];
        
        for (NSString* file in files) {
            if (![[file pathExtension] isEqualToString:@"txt"]) {
                continue;
            }
            NSDictionary* template = @{
                @"证券名称":@0,
                @"成交日期":@1,
                @"成交价格":@2,
                @"成交数量":@5,
                @"发生金额":@8,
                @"业务名称":@19,
                @"手续费":@20,
                @"印花税":@23,
                @"过户费":@26,
                @"结算费":@29,
                };
            NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
            NSData* data = [NSData dataWithContentsOfFile:[folder stringByAppendingPathComponent:file]];
            NSString* s = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, [data length])] encoding:encode];
            NSArray* a = [s componentsSeparatedByString:@"\n"];
            for (NSString* l in [a subarrayWithRange:NSMakeRange(1, [a count] - 1)]) {
                if ([l length] == 0) {
                    continue;
                }
                NSArray* field = [l componentsSeparatedByString:@" "];
                NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:template];
                for (NSString* k in template) {
                    r[k] = [field objectAtIndex:[r[k] integerValue]];
                }
                if (NSNotFound == [r[@"业务名称"] rangeOfString:@"买入"].location) {
                    brain.buy.price = [r[@"交易价格"] doubleValue];
                    brain.buy.quantity = [r[@"成交数量"] doubleValue];
                    [brain calculateForPurchase];
                    
                }
                else {
                    brain.sell.price = [r[@"交易价格"] doubleValue];
                    brain.sell.quantity = [r[@"成交数量"] doubleValue];
                    [brain calculateForSale];
                }
                if (0.01 > fabs(brain.result - [r[@"发生金额"] doubleValue])) {
                    NSLog(@"[success]%@ %f", l, brain.result);
                    
                }
                else {
                    NSLog(@"[\e[31mfail\e[0m]%@", l);
                }
                [record addObject:r];
                
            }
            
        }
    }
    return 0;
}
