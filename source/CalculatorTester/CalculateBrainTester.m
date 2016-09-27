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
        //NSSearchPathForDirectoriesInDomains(
        for (NSString* file in files) {
            if ([[file pathExtension] isEqualToString:@"txt"]) {
                //NSStringEncoding encode = NSUTF8StringEncoding;
                NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
                NSData* data = [NSData dataWithContentsOfFile:[folder stringByAppendingPathComponent:file]];
                NSString* s = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, [data length])] encoding:encode];
                NSLog(@"%@", s);
            }
            
        }

        //CalculateBrain* brain = [[CalculateBrain alloc]init];
    }
    return 0;
}
