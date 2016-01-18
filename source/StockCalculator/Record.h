//
//  Record.h
//  StockCalculator
//
//  Created by jack on 15/11/11.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"

@interface Record : NSObject
@property SQLiteManager* db;
+ (instancetype) sharedRecord;
- (BOOL)add:(NSDictionary*)record;
- (NSUInteger)count;
-(NSDictionary*)recordForIndexPath:(NSInteger)indexPath;
- (void)removeAtIndex:(NSInteger)index;
-(NSArray*)recordsForCondition:(NSString*)condition like:(NSString*)v;
-(NSArray*)recordsAtTime:(NSString*)time;
-(NSArray*)recordsForCode:(NSString*)code;
//-(NSArray*)recordsForPrice:(NSString*)price;
//-(NSArray*)recordsForQuantity:(NSString*)quantity;
@end
static Record* instance;