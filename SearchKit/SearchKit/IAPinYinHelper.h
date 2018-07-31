//
//  IAPinYinHelper.h
//  SearchKit
//
//  Created by Alter on 2018/7/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPinYinHelper : NSObject

+ (BOOL)hasChineseWithString:(NSString *)string;

/**
 系统中文转拼音的方法，不可识别多音字

 @param string 需要转换的字符串，可以包含数字英文，对转换无影响
 @return 转成拼音的结果
 */
+ (NSString *)toSystemPinyinWithString:(NSString *)string;


+ (NSArray <NSArray *> *)toPinyinArrsWithString:(NSString *)string;

/**
 获取给定字符串的全拼数组，当存在多音字时，会有多个返回

 @param string 需要转换的字符串，可以包含数字英文，对转换无影响
 @return 全拼数组
 */
+ (NSArray *)toPinyinWithString:(NSString *)string;


+ (NSArray <NSArray *> *)toPinyinInitialArrsWithString:(NSString *)string;

/**
 获取给定字符串的首字母组合数组，当存在多音字时，会有多个返回

 @param string 需要转换的字符串，可以包含数字英文，对转换无影响
 @return 首字母组合结果
 */
+ (NSArray *)toPinyinInitialWithString:(NSString *)string;

@end
