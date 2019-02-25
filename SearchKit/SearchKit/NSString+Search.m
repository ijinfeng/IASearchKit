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
    
    NSRange r = [self rangeOfString:realKey];
    if (r.location != NSNotFound) {
        *range = r;
        return YES;
    }
    
    // 优先拼音首字母
    NSArray *stringPinyinInitials = [IAPinYinHelper toPinyinInitialWithString:self];
    for (NSString *stringPinyinInitial in stringPinyinInitials) {
        NSRange r = [stringPinyinInitial rangeOfString:realKey];
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
        NSRange r = [stringPinyin rangeOfString:realKey];
        if (r.location != NSNotFound) {
            // 获取匹配到的那组拼音字串的每个字符的拼音组合
            NSArray *pinyin = pinyins[index];
    
            NSUInteger _index = 0; // 记录的字符下标
            NSUInteger _count = 0; // 当前记录的拼音的总长度
            NSUInteger _lastCount = 0;// 记录上一次的拼音总长度
            unsigned int _length = (unsigned int)r.length; // 记录下匹配到的拼音的长度
            BOOL match = NO;
            
            for (NSString *pinyinStr in pinyin) {
                unsigned int currentPinyinLength = (unsigned int)pinyinStr.length;
                _count += currentPinyinLength;
                if ((r.location + 1) >= _lastCount && ((r.location + 1) <= _count)) {
                    r.location = _index;
                    r.length = 1;
                    match = YES;
                }
                if (match) {
                    if (_length > currentPinyinLength) {
                        r.length++;
                        _length -= currentPinyinLength;
                    } else {
                        break;
                    }
                }
                
                _index++;
                _lastCount += currentPinyinLength;
            }
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
    
    NSArray *rs = [self getRangesWithKeyword:realKey];
    if (rs.count != 0) {
        *ranges = rs;
        return YES;
    }
    
    // 优先拼音首字母
    NSArray *stringPinyinInitials = [IAPinYinHelper toPinyinInitialWithString:self];
    for (NSString *stringPinyinInitial in stringPinyinInitials) {
        NSArray *rs = [stringPinyinInitial getRangesWithKeyword:realKey];
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
        NSArray *rs = [stringPinyin getRangesWithKeyword:realKey];
        NSMutableArray *newRanges;
        if (rs.count != 0) {
            newRanges = [NSMutableArray arrayWithCapacity:rs.count];
        }
        for (NSValue *rv in rs) {
            NSRange r = rv.rangeValue;
            
            if (r.location != NSNotFound) {
                // 获取匹配到的那组拼音字串的每个字符的拼音组合
                NSArray *pinyin = pinyins[index];
                
                NSUInteger _index = 0; // 记录的字符下标
                NSUInteger _count = 0; // 当前记录的拼音的总长度
                NSUInteger _lastCount = 0;// 记录上一次的拼音总长度
                unsigned int _length = (unsigned int)r.length; // 记录下匹配到的拼音的长度
                BOOL match = NO;
                
                for (NSString *pinyinStr in pinyin) {
                    unsigned int currentPinyinLength = (unsigned int)pinyinStr.length;
                    _count += currentPinyinLength;
                    if ((r.location + 1) >= _lastCount && ((r.location + 1) <= _count)) {
                        r.location = _index;
                        r.length = 1;
                        match = YES;
                    }
                    if (match) {
                        if (_length > currentPinyinLength) {
                            r.length++;
                            _length -= currentPinyinLength;
                        } else {
                            break;
                        }
                    }
                    
                    _index++;
                    _lastCount += currentPinyinLength;
                }
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

@end
