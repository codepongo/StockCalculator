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

BOOL deleteDBFile() {
    NSError* error = nil;
    SQLiteManager* db = [[SQLiteManager alloc] init];
    NSString* path = [[db getDatabasePath] stringByAppendingPathComponent:@"stockcalc.db"];
    [[NSFileManager defaultManager] removeItemAtPath: path error: &error];
    if (error != nil) {
        NSLog(@"%s: %@", __FUNCTION__, [error localizedDescription]);
        return NO;
    }
    return YES;
}

void testRecord() {
    //initialize
    
    {
        deleteDBFile();
        Record* r = [Record sharedRecord];
        {
            
            NSDictionary* t = @{
                                @"buy.price" : @"5.33",
                                @"buy.quantity" : @2400,
                                @"code" :@601939,
                                @"commission" : @10,
                                @"fee" : @"23.23",
                                @"rate.commission" : @"0.31",
                                @"rate.stamp" : @1,
                                @"rate.transfer" : @"0.02",
                                @"result" : @"-95.22",
                                @"sell.price" : @"5.3",
                                @"sell.quantity" : @2400,
                                @"stamp" : @"12.72",
                                @"transfer" : @"0.51",
                                @"type" : @"损益计算"
                                };
            BOOL ret = [r add:t];
            if (!ret) {
                NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, @"Record::add");
                exit(-1);
            };
        }
        {
            NSDictionary* t = @{
                                @"buy.price" : @31,
                                @"buy.quantity" :@500,
                                @"code" : @000623,
                                @"commission" : @10,
                                @"fee" : @"26.15",
                                @"rate.commission" : @"0.31",
                                @"rate.stamp" : @1,
                                @"rate.transfer" : @"0.02",
                                @"result" : @"3.850000000000364",
                                @"stamp" : @"15.53",
                                @"transfer" : @"0.62",
                                @"type" : @"保本价格"
                                };
            BOOL ret = [r add:t];
            if (!ret) {
                NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, @"Record::add");
                exit(-1);
            };
            

        }
        //NSLog(@"%@", [r.db getDatabaseDump]);
        [r.db closeDatabase];
        [Record release];
        NSLog(@"==Initialize case is successful==");
    }
    
    //update
    {
        deleteDBFile();
        SQLiteManager* db = [[SQLiteManager alloc]initWithDatabaseNamed:@"stockcalc.db"];
        [db doQuery:@"CREATE TABLE record ([code] TEXT, [buy.price] FLOAT, [buy.quantity] FLOAT, [sell.price] FLOAT, [sell.quantity] FLOAT, [rate.commission] FLOAT, [rate.stamp] Float, [rate.transfer] Float,[commission] FLOAT, [stamp] Float, [transfer] Float, [fee] FLOAT, [result] FLOAT, [time] TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));"];
        NSError* error = nil;
        error = [db doQuery:@"insert into record ('rate.commission','rate.transfer','buy.price','buy.quantity',fee,time,'sell.price',transfer,code,'sell.quantity','rate.stamp',stamp,commission,result) values (0.31,0.02,5.33,2400,23.23,'2016-10-15 14:34:53',5.3,0.51,'601939',2400,1,12.72, 10, -95.22);"];
        if (error != nil) {
            NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, [error localizedDescription]);
            exit(-1);
        }
        error = [db doQuery:@"insert into record ('rate.commission','rate.transfer','buy.price','buy.quantity',fee,time,'sell.price',transfer,code,'sell.quantity','rate.stamp',stamp,commission,result) values (0.31,0.02,31,500,26.15,'2016-10-15 14:57:22',null,0.62,'403',null,1,15.53,10,3.85);"];
        if (error != nil) {
            NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, [error localizedDescription]);
            exit(-1);
        }
        [db closeDatabase];
        Record* r = [Record sharedRecord];
        if (error != nil){
            NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, [error localizedDescription]);
            exit(-1);
            
        }

        NSLog(@"%@", [r.db getDatabaseDump]);
        [Record release];
        NSLog(@"==update case is successful==");
    }
    //normal
    {
        deleteDBFile();
        Record* r = [Record sharedRecord];
        {
            NSDictionary* t = @{
                                @"buy.price" : @17,
                                @"buy.quantity" : @500,
                                @"code" : @000001,
                                @"commission" : @5,
                                @"fee" : @"5.17",
                                @"rate.commission" : @"0.31",
                                @"rate.stamp" : @1,
                                @"rate.transfer" : @"0.02",
                                @"result" : @"8505.17",
                                @"stamp" : @0,
                                @"transfer" : @"0.17",
                                @"type" : @"买入支出"
                                };
            BOOL ret = [r add:t];
            if (!ret) {
                NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, @"Record::add");
                exit(-1);
            };
        }
        {
            NSDictionary* t = @{
                                @"code" : @000003,
                                @"commission" : @5,
                                @"fee" : @"10.1",
                                @"rate.commission" : @"0.31",
                                @"rate.stamp" : @1,
                                @"rate.transfer" : @"0.02",
                                @"result" : @"4989.9",
                                @"sell.price" : @10,
                                @"sell.quantity" : @500,
                                @"stamp" : @5,
                                @"transfer" : @"0.1",
                                @"type" : @"卖出收入"
                                };
            BOOL ret = [r add:t];
            if (!ret) {
                NSLog(@"[\e[31mfail\e[0m][%s(%d)-%s]0%@", __FILE__, __LINE__, __FUNCTION__, @"Record::add");
                exit(-1);
            };
        }
        [Record release];
        NSLog(@"==normal case is successful==");
        NSLog(@"%@", [r.db getDatabaseDump]);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testRecord();
        NSString* folder = [@"~/Documents/trade" stringByExpandingTildeInPath];
        if (argv[1] != NULL) {
            
            folder = [[NSString alloc] initWithUTF8String:argv[1]];
        }
        //testBrain(folder);
        
    }
    return 0;
}

