//
//  NSArray+Combine.h
//  SearchKit
//
//  Created by Alter on 2018/7/25.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Combine)

/**
 根据给定的items数组，从每个元素中各取一个数，返回所有可能的组合
 可以是多个数组组成的二维数组：[[a,b],[c,d,e],[f],[g],[h,g]...]
 
 递归法
 
 @return 返回 [a,c,f,g,h...] 或者 [a,d,f,g,h...] 或者...
 */
- (NSArray *)combine;

// 暂定
- (NSArray *)combine2;


/**
 把数组中的字符串元素合并
 可以是多个数组组成的二维数组：[[a],[e],[f],[g],[h]...]
 
 递归法

 @return 返回 [aefgh...] 或者...
 */
- (NSArray *)combineToString;

@end
