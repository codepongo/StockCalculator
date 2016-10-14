//
//  main.m
//  CalculatorTester
//
//  Created by zuohaitao on 20/9/2016.
//  Copyright © 2016 zuohaitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockCalculator-Swift.h"


void testBrain(NSString* folder) {
    CalculateBrain* brain = [[CalculateBrain alloc]init];
    [brain.rate setValue:[NSNumber numberWithDouble:0.31] forKey:@"commission"];
    [brain.rate setValue:[NSNumber numberWithDouble:1] forKey:@"stamp"];
    [brain.rate setValue:[NSNumber numberWithDouble:0.02] forKey:@"transfer"];
    
    NSError* err;

    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&err];
    NSMutableArray* record = [NSMutableArray arrayWithCapacity:[files count] * 10];
    
    for (NSString* file in files) {
        if (![[file pathExtension] isEqualToString:@"txt"]) {
            continue;
        }
        NSDictionary* template = @{
                                   @"证券名称":@1,
                                   @"成交日期":@2,
                                   @"成交价格":@3,
                                   @"成交数量":@4,
                                   @"发生金额":@5,
                                   @"业务名称":@9,
                                   @"手续费":@10,
                                   @"印花税":@11,
                                   @"过户费":@12,
                                   @"结算费":@13,
                                   @"证券代码":@14,
                                   };
        NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
        NSData* data = [NSData dataWithContentsOfFile:[folder stringByAppendingPathComponent:file]];
        NSString* s = [[NSString alloc] initWithData:data encoding:encode];
        NSArray* a = [s componentsSeparatedByString:@"\n"];
        for (NSString* l in [a subarrayWithRange:NSMakeRange(3, [a count] - 3)]) {
            if ([l length] == 0) {
                continue;
            }
            NSString* line = l;
            while (NSNotFound != [line rangeOfString:@"  "].location) {
                line = [line stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            }
            NSArray* field = [line componentsSeparatedByString:@" "];
            NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:template];
            for (NSString* k in template) {
                r[k] = [field objectAtIndex:[r[k] integerValue]];
            }
            if ([r[@"证券代码"] isEqualToString:@"---"]
                || [r[@"证券代码"] isEqualToString:@"131810"]
                || [r[@"证券代码"] isEqualToString:@"510900"]
                || [r[@"证券代码"] isEqualToString:@"159915"]
                || [r[@"证券代码"] isEqualToString:@"510300"]
                || [r[@"证券代码"] isEqualToString:@"980517895605"]
                || [r[@"证券代码"] isEqualToString:@"880013"]
                ) {
                continue;
            }
            if ([[r[@"证券代码"] substringToIndex:1] isEqualToString:@"6"]) {
                brain.inSZ = NO;
            }
            else {
                brain.inSZ = YES;
            }
            if (NSNotFound != [r[@"业务名称"] rangeOfString:@"买入"].location) {
                brain.purchase.price = [r[@"成交价格"] doubleValue];
                brain.purchase.quantity = [r[@"成交数量"] doubleValue];
                [brain calculateForPurchase];
                
            }
            else {
                brain.sale.price = [r[@"成交价格"] doubleValue];
                brain.sale.quantity = fabs([r[@"成交数量"] doubleValue]);
                [brain calculateForSale];
            }
            if (fabs(0.01 - fabs(brain.result - fabs([r[@"发生金额"] doubleValue]))) <= 0.01) {
                NSLog(@"[success]");
                
            }
            else {
                NSLog(@"[\e[31mfail\e[0m]%@", l);
            }
            [record addObject:r];
            
        }
        
    }
}

#import "../StockCalculator/Record.h"

void testRecord() {
    //initialize
    //[[NSFileManager defaultManager] removeItemAtPath: @"initialize.db" error: nil];
    //self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"initialize.db"];
    Record* r = [Record sharedRecord];
    
    //update
    //[[NSFileManager defaultManager] removeItemAtPath: @"update.db" error: nil];
    //self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"update.db"];

    //normal
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testRecord();
        NSString* folder = [@"~/Documents/trade" stringByExpandingTildeInPath];
        if (argv[1] != NULL) {
            
            folder = [[NSString alloc] initWithUTF8String:argv[1]];
        }
        testBrain(folder);
        
    }
    return 0;
}

