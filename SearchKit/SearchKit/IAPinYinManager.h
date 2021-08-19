//
//  IAPinYinManager.h
//  SearchKit
//
//  Created by Alter on 2018/7/18.
//  Copyright © 2018年 Netease. All rights reserved.
//
//
//    http://kanji.zinbun.kyoto-u.ac.jp/~yasuoka/CJK.html
//    中文unicode值以及对应的拼音（支持多音字）
//

#import <Foundation/Foundation.h>

@interface IAPinYinManager : NSObject

+ (instancetype)shared;

/**
 加载中文unicode表到内存中
 请在合适的时机把拼音文件加载到内存中
 */
- (void)loadPinyinData;
/// 全拼
@property (nonatomic, strong, readonly) NSDictionary *pinyinDic; 
/// 首字母
@property (nonatomic, strong, readonly) NSDictionary *initialDic;

@end

