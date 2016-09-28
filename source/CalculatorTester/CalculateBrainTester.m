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
            NSLog(@"%@", file);
            for (NSString* l in [a subarrayWithRange:NSMakeRange(1, [a count] - 1)]) {
                if ([l length] == 0) {
                    continue;
                }
                //NSLog(l);
                NSArray* field = [l componentsSeparatedByString:@" "];
                NSMutableDictionary *r = [NSMutableDictionary dictionaryWithDictionary:template];
                for (NSString* k in template) {
                    r[k] = [field objectAtIndex:[r[k] integerValue]];
                }
                [record addObject:r];
                
            }
            
        }
        //CalculateBrain* brain = [[CalculateBrain alloc]init];
    }
    return 0;
}
