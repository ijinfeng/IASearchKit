//
//  IAPinYinManager.m
//  SearchKit
//
//  Created by Alter on 2018/7/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "IAPinYinManager.h"

@interface IAPinYinManager()

@property (nonatomic, strong) NSMutableDictionary *mpinyinDic; // 全拼

@property (nonatomic, strong) NSMutableDictionary *minitialDic; // 首字母

@property (nonatomic, strong) NSDictionary *pinyinDic; // 全拼

@property (nonatomic, strong) NSDictionary *initialDic; // 首字母

@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation IAPinYinManager

+ (instancetype)shared {
    static IAPinYinManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IAPinYinManager alloc] init];
        instance.hasLoaded = NO;
    });
    return instance;
}

- (void)loadPinyinData {
    if (self.hasLoaded) {
        NSLog(@"You‘ve already loaded it!");
        return;
    }
    
    [self startToLoadData];
}

- (void)startToLoadData {
    self.hasLoaded = YES;
    
    self.mpinyinDic = [NSMutableDictionary dictionary];
    self.minitialDic = [NSMutableDictionary dictionary];
    
    NSString *dataPath = [[NSBundle bundleForClass:self.class] pathForResource:@"IAUni2Pinyin" ofType:@"txt"];
    NSFileHandle *readHandler = [NSFileHandle fileHandleForReadingAtPath:dataPath];
    NSString *string = [[NSString alloc] initWithData:readHandler.availableData encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *unicodeLineArr = [string componentsSeparatedByString:@"\n"];
    for (NSString *unicodeLine in unicodeLineArr) {
        NSArray *unicodeValues = [unicodeLine componentsSeparatedByString:@"\t"];
        NSString *unicode = unicodeValues.firstObject;
        NSArray *pinyins = [unicodeValues subarrayWithRange:NSMakeRange(1, unicodeValues.count - 1)];
        NSMutableArray *_pinyins = [NSMutableArray arrayWithCapacity:pinyins.count];
        NSMutableSet *_initials = [NSMutableSet setWithCapacity:pinyins.count];
        for (NSString *pinyin in pinyins) {
            NSString *n = [pinyin substringFromIndex:pinyin.length - 1];
            if ([@[@"0",@"1",@"2",@"3",@"4",@"5"] containsObject:n]) {
                [_pinyins addObject:[pinyin substringToIndex:pinyin.length - 1]];
            } else {
                [_pinyins addObject:pinyin];
            }
            [_initials addObject:[pinyin substringToIndex:1]];
        }
        unicode = [NSString stringWithFormat:@"\\u%@",unicode];
        NSString *key = [self replaceUnicode:unicode];
        [self.mpinyinDic setObject:[_pinyins copy] forKey:key];
        [self.minitialDic setObject:[_initials allObjects] forKey:key];
    }
    
    self.pinyinDic = [self.mpinyinDic copy];
    self.initialDic = [self.minitialDic copy];
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr;
    if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_0) {
        returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                              options:NSPropertyListImmutable
                                                               format:NULL
                                                                error:NULL];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                     mutabilityOption:NSPropertyListImmutable
                                                               format:NULL
                                                     errorDescription:NULL];
#pragma clang diagnostic pop
    }

    return returnStr;
}

@end
