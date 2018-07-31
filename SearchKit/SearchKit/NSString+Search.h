//
//  NSString+Search.h
//  SearchKit
//
//  Created by Alter on 2018/7/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Search)

/**
 获取一段文本中的关键字的 range

 @param keyword 关键字
 @return range数组
 */
- (NSArray <NSValue *> *)getRangesWithKeyword:(NSString *)keyword;

/**
 获取一段文本中多个关键字的 range

 @param keywords 一组关键字
 @return 返回关键字-匹配范围的字典 {keyword : ranges}
 */
- (NSDictionary *)getRangesWithKeywords:(NSArray *)keywords;


/**
 根据输入的关键字是否能够匹配

 @param keyword 关键字，支持拼音，不区分大小写
 @param range 匹配到的第一个范围
 @return 是否匹配
 */
- (BOOL)canMatchWithKeyword:(NSString *)keyword
                      range:(NSRange *)range;

/**
 根据输入的关键字是否能够匹配
 
 @param keyword 关键字，支持拼音，不区分大小写
 @param ranges 匹配到的所有范围
 @return 是否匹配
 */
- (BOOL)canMatchWithKeyword:(NSString *)keyword
                  allRanges:(NSArray *__autoreleasing *)ranges;
@end
