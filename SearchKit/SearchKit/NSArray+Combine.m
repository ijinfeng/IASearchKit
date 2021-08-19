//
//  NSArray+Combine.m
//  SearchKit
//
//  Created by Alter on 2018/7/25.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "NSArray+Combine.h"

@implementation NSArray (Combine)

- (NSArray *)combine {
    if (![self.firstObject isKindOfClass:[NSArray class]] || self.count == 0) {
        return self;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    [self getCombnineOneWithItems:self results:results dindex:0 oneResult:[NSMutableArray array]];
    return results.copy;
}

- (void)getCombnineOneWithItems:(NSArray *)items
                        results:(NSMutableArray *)results
                         dindex:(NSUInteger)dindex
                      oneResult:(NSMutableArray *)oneResult {
    if (dindex == items.count) {
        [results addObject:oneResult.copy];
        return;
    }
    
    for (id obj in items[dindex]) {
        oneResult[dindex] = obj;
        [self getCombnineOneWithItems:items results:results dindex:dindex + 1 oneResult:oneResult];
    }
}

// string
- (NSArray *)combineToString {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.count];
    for (NSArray *all in self) {
        NSMutableString *string = [NSMutableString string];
        for (NSString *c in all) {
            [string appendString:c];
        }
        [results addObject:string.copy];
    }
    return results.copy;
}

@end
