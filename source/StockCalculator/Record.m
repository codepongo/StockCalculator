//
//  Record.m
//  StockCalculator
//
//  Created by zuohaitao on 15/11/11.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "Record.h"
#import "Rate.h"
#import "StockCalculator-Swift.h"
@interface Record()
-(instancetype)init;
@end
@implementation Record
+ (instancetype)sharedRecord {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[Record alloc] init];
            return instance;
        }
        return instance;
    }
}

-(instancetype)init {
    if (self = [super init]) {
        self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"stockcalc.db"];
        
        
        {
            NSString* sqlSentence = @"CREATE TABLE record ([code] TEXT, [buy.price] FLOAT, [buy.quantity] FLOAT, [sell.price] FLOAT, [sell.quantity] FLOAT, [rate.commission] FLOAT, [rate.stamp] Float, [rate.transfer] Float,[commission] FLOAT, [stamp] Float, [transfer] Float, [fee] FLOAT, [result] FLOAT, [time] TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));";

            NSString* sql_for_creation = @"select sql from sqlite_master where tbl_name='record'";
            
            NSArray* r = [self.db getRowsForQuery:sql_for_creation];
        
            if (r.count >= 1) {
                if (![sqlSentence isEqualToString:r[0][@"sql"]]) {
                    [self.db doQuery:@"ALTER TABLE record ADD type TEXT"];
                    NSArray* record = [self.db getRowsForQuery:@"select * from record"];
                    
                    for (id r in record) {
                        if (r[@"sell.price"] == [NSNull null]) {
                            r[@"type"] = @"保本价格";
                        }
                        else {
                            r[@"type"] = @"交易损益";
                        }
                        [self add:r];
                    }
                    
                }

            }
        }

        /*
        {
            NSFileManager *f = [NSFileManager defaultManager];
            BOOL bRet = [f fileExistsAtPath:[self.db getDatabasePath]];
            if (bRet) {
                NSError *err;
                [f removeItemAtPath:[self.db getDatabasePath] error:&err];
            }
            self.db = [[SQLiteManager alloc]initWithDatabaseNamed:@"stockcalc.db"];
            
        }
         */
        
        NSString* sqlSentence = @"CREATE TABLE IF NOT EXISTS record ([code] TEXT, [buy.price] FLOAT, [buy.quantity] FLOAT, [sell.price] FLOAT, [sell.quantity] FLOAT, [rate.commission] FLOAT, [rate.stamp] Float, [rate.transfer] Float,[commission] FLOAT, [stamp] Float, [transfer] Float, [fee] FLOAT, [result] FLOAT, [time] TimeStamp NOT NULL DEFAULT (datetime('now','localtime')));";

        
        NSError *error = [self.db doQuery:sqlSentence];
        
        if (error != nil) {
            //NSLog(@"Error: %@",[error localizedDescription]);
            return nil;
        }
        
        return self;
    }
    return nil;
}

-(BOOL)add:(NSDictionary*)record{

    NSMutableArray* keys = [NSMutableArray arrayWithCapacity:14];
    for (NSString* k in [record allKeys]) {
        [keys addObject:[NSString stringWithFormat:@"[%@]", k]];
    }
    
    NSMutableArray* values = [NSMutableArray arrayWithCapacity:[[record allValues]count]];

    for (id v in [record allValues]) {
        NSString* value = v;
        if ([v isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"'%@'", v];
        }
        [values addObject:value];
    }
    
    NSString *sqlSentence = [NSString stringWithFormat:@"INSERT INTO record (%@) values (%@);",[keys componentsJoinedByString:@","], [values componentsJoinedByString:@","]];

    NSError *error = [self.db doQuery:sqlSentence];
    if (error != nil) {
        //NSLog(@"Error: %@",[error localizedDescription]);
        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordChanged" object:nil];
    return YES;
    
}

-(NSUInteger)count {
    NSArray* r = [self.db getRowsForQuery:@"SELECT count(*) FROM record"];
    return ((NSNumber*)r[0][@"count(*)"]).integerValue;
}

-(NSArray*)getRecords:(NSRange)range {
    NSString* sql = [NSString stringWithFormat:@"SELECT ROWID,* FROM record ORDER BY ROWID DESC LIMIT %lu OFFSET %lu",  (unsigned long)range.length, (unsigned long)range.location];
    NSArray* r = [self.db getRowsForQuery:sql];
    return r;
}

-(NSDictionary*)recordForIndexPath:(NSInteger)indexPath {
    NSRange range = {indexPath, 1};
    NSArray* r = [self getRecords:range];
    return r[0];
    
}
-(void)removeAtIndex:(NSInteger)index {
    NSString *sqlSentence = [NSString stringWithFormat:@"DELETE FROM record WHERE ROWID=%ld", (long)index];
    
    NSError *error = [self.db doQuery:sqlSentence];
    if (error != nil) {
        //NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordChanged" object:nil];
    return;
}

-(NSArray*)recordsForCondition:(NSString *)condition like:(NSString *)v {
    NSString* sql = [NSString stringWithFormat:@"SELECT ROWID,* FROM record WHERE %@ like '%%%@%%' ORDER BY ROWID DESC ", condition, v];
    return [self.db getRowsForQuery:sql];
}

-(NSArray*)recordsForCode:(NSString*) v {
    return [self recordsForCondition:@"code" like:v];
}

//-(NSArray*)recordsForPrice:(NSString*) v {
//    return [[self recordsForCondition:@"[buy.price]" like:v] arrayByAddingObjectsFromArray:[self recordsForCondition:@"[sell.price]" like:v]];
//}
//
//-(NSArray*)recordsForQuantity:(NSString*) v {
//    return [[self recordsForCondition:@"[buy.quantity]" like:v] arrayByAddingObjectsFromArray:[self recordsForCondition:@"[sell.quantity]" like:v]];
//}

-(NSArray*)recordsAtTime:(NSString*) v {
    return [self recordsForCondition:@"time" like:v];
}
@end
