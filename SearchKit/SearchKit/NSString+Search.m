//
//  NSString+Search.m
//  SearchKit
//
//  Created by Alter on 2018/7/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "NSString+Search.h"
#import "IAPinYinHelper.h"
#import "NSArray+Combine.h"
#import "IAPinYinManager.h"

@implementation NSString (Search)

- (NSArray <NSValue *> *)getRangesWithKeyword:(NSString *)keyword {
    NSMutableArray *ranges = [NSMutableArray array];

    NSRange last_r = NSMakeRange(0, self.length);
    while (1) {
        if (last_r.location > self.length - keyword.length) {
            break;
        }
        NSRange r = [self rangeOfString:keyword options:NSLiteralSearch range:last_r];
        if (r.location == NSNotFound) {
            break;
        }
        last_r.location = r.location + keyword.length;
        last_r.length = self.length - last_r.location;
        
        [ranges addObject:[NSValue valueWithRange:r]];
    }
    
    return [ranges copy];
}

- (NSDictionary *)getRangesWithKeywords:(NSArray *)keywords {
    NSMutableDictionary *rangeDic = [NSMutableDictionary dictionaryWithCapacity:keywords.count];
    
    for (NSString *keyword in keywords) {
        NSArray *ranges = [self getRangesWithKeyword:keyword];
        [rangeDic setObject:ranges forKey:keyword];
    }
    
    return [rangeDic copy];
}

- (BOOL)canMatchWithKeyword:(NSString *)keyword range:(NSRange *)range {
    if (!keyword || keyword.length == 0 || self.length == 0) {
        return NO;
    }
    // 转成小写
    NSString *realKey = [keyword lowercaseString];
    
    NSRange r = [self.lowercaseString rangeOfString:realKey];
    if (r.location != NSNotFound) {
        *range = r;
        return YES;
    }
    
    // 优先拼音首字母
    NSArray *stringPinyinInitials = [IAPinYinHelper toPinyinInitialWithString:self];
    for (NSString *stringPinyinInitial in stringPinyinInitials) {
        NSRange r = [stringPinyinInitial.lowercaseString rangeOfString:realKey];
        if (r.location != NSNotFound) {
            *range = r;
            return YES;
        }
    }
    
    // 全拼
    NSArray *pinyins = [IAPinYinHelper toPinyinArrsWithString:self];
    NSArray *stringPinyins = [pinyins combineToString];
    
    for (NSUInteger index = 0; index < stringPinyins.count; index++) {
        NSString *stringPinyin = stringPinyins[index];
        NSRange r = [stringPinyin.lowercaseString rangeOfString:realKey];
        if (r.location != NSNotFound) {
            // 获取匹配到的那组拼音字串的每个字符的拼音组合
            NSArray *pinyin = pinyins[index];
            
            NSUInteger _count = 0; // 当前已经记录的拼音的总长度，不包括当前这个拼音，用于和比较是否位于 range 内部
            NSUInteger count = pinyin.count;
            NSInteger location = -1;
            NSUInteger length = 0;
            
            for (int i = 0; i < count; i++) {
                NSString *pinyinStr = pinyin[i];
                _count += pinyinStr.length;

                if (_count > r.location && location == -1) {
                    location = i;
                }
                if (location >= 0) {
                    length += 1;
                }
                if (_count >= r.location + r.length) {
                    break;
                }
                
            }
            r = NSMakeRange(location, length);
            *range = r;
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canMatchWithKeyword:(NSString *)keyword allRanges:(NSArray *__autoreleasing *)ranges {
    if (!keyword || keyword.length == 0 || self.length == 0) {
        return NO;
    }
    // 转成小写
    NSString *realKey = [keyword lowercaseString];
    
    // 非纯英文
    // 纯英文+精准匹配
    if (![realKey isPureEnglish]) {
        // 精准匹配
        NSArray *rs = [self.lowercaseString getRangesWithKeyword:realKey];
        if (rs.count != 0) {
            *ranges = rs;
            return YES;
        }
    }
    
    // 优先拼音首字母
    NSArray *stringPinyinInitials = [IAPinYinHelper toPinyinInitialWithString:self];
    for (NSString *stringPinyinInitial in stringPinyinInitials) {
        NSArray *rs = [stringPinyinInitial.lowercaseString getRangesWithKeyword:realKey];
        if (rs.count != 0) {
            *ranges = rs;
            return YES;
        }
    }
    
    // 全拼
    NSArray *pinyins = [IAPinYinHelper toPinyinArrsWithString:self];
    NSArray *stringPinyins = [pinyins combineToString];
    
    for (NSUInteger index = 0; index < stringPinyins.count; index++) {
        NSString *stringPinyin = stringPinyins[index];
        NSArray *rs = [stringPinyin.lowercaseString getRangesWithKeyword:realKey];
        NSMutableArray *newRanges;
        if (rs.count != 0) {
            newRanges = [NSMutableArray arrayWithCapacity:rs.count];
        }
        for (NSValue *rv in rs) {
            NSRange r = rv.rangeValue;
            
            if (r.location != NSNotFound) {
                // 获取匹配到的那组拼音字串的每个字符的拼音组合
                NSArray *pinyin = pinyins[index];
                
                NSUInteger _count = 0; // 当前已经记录的拼音的总长度，不包括当前这个拼音，用于和比较是否位于 range 内部
                NSUInteger count = pinyin.count;
                NSInteger location = -1;
                NSUInteger length = 0;
                
                for (int i = 0; i < count; i++) {
                    NSString *pinyinStr = pinyin[i];
                    _count += pinyinStr.length;

                    if (_count > r.location && location == -1) {
                        location = i;
                    }
                    if (location >= 0) {
                        length += 1;
                    }
                    if (_count >= r.location + r.length) {
                        break;
                    }
                    
                }
                r = NSMakeRange(location, length);
                [newRanges addObject:[NSValue valueWithRange:r]];
            }
        }
        if (newRanges.count != 0) {
            *ranges = newRanges.copy;
            return YES;
        }
    }
    
    return NO;
}

/// 是否为纯英文
- (BOOL)isPureEnglish {
    NSString *regex = @"[a-zA-Z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicate evaluateWithObject:self];
}

@end
