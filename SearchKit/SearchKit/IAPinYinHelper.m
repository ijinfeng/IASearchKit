//
//  IAPinYinHelper.m
//  SearchKit
//
//  Created by Alter on 2018/7/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "IAPinYinHelper.h"
#import "IAPinYinManager.h"
#import "NSArray+Combine.h"

@implementation IAPinYinHelper

+ (BOOL)hasChineseWithString:(NSString *)string {
    for (int i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)toSystemPinyinWithString:(NSString *)string {
    NSMutableString *fromString = [string mutableCopy];
    // 将转换完的结果全部输出
    Boolean result = CFStringTransform((CFMutableStringRef)fromString, NULL, kCFStringTransformMandarinLatin, NO);
    // 去掉变音符号
    CFStringTransform((CFMutableStringRef)fromString, NULL, kCFStringTransformStripDiacritics, NO);
    
    if (!result) {
        return nil;
    }
    return fromString.copy;
}

+ (NSArray<NSArray *> *)toPinyinArrsWithString:(NSString *)string {
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        NSArray *pinyins = [[IAPinYinManager shared].pinyinDic valueForKey:s];
        if (pinyins == nil) {
            pinyins = @[s];
        }
        [items addObject:pinyins];
    }
    return [items combine];
}

+ (NSArray *)toPinyinWithString:(NSString *)string {
    return [[self toPinyinArrsWithString:string] combineToString];
}

+ (NSArray<NSArray *> *)toPinyinInitialArrsWithString:(NSString *)string {
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < string.length; i++) {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        NSArray *pinyins = [[IAPinYinManager shared].initialDic valueForKey:s];
        if (pinyins == nil) {
            pinyins = @[s];
        }
        [items addObject:pinyins];
    }
    return [items combine];
}

+ (NSArray *)toPinyinInitialWithString:(NSString *)string {
    return [[self toPinyinInitialArrsWithString:string] combineToString];
}

@end
