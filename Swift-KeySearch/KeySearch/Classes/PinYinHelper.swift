//
//  PinYinHelper.swift
//  KeySearch
//
//  Created by jinfeng on 2021/8/19.
//

import Foundation

public extension String {
    
    /// 判断字符串中是否有中文
    /// - Returns: 有：true，没有：false
    func hasChinese() -> Bool {
        for c in self.unicodeScalars {
            if c.value > 0x4e00 && c.value < 0x9fff {
                return true
            }
        }
        return false
    }
    
    /// 将给定字符串以拼音数组的方式返回，存在多音字时会返回多个
    /// - Returns: [["ni","hao","a"]]
    func transferPinyinArrs() -> [[String]] {
        var items: [[String]] = []
        for c in self {
            let cs = "\(c)"
            var pinyins = PinYinManager.shared.pinyinDic[cs]
            if pinyins == nil {
                pinyins = [cs]
            }
            items.append(pinyins!)
        }
        return items.combine()
    }
    
    /// 将给定字符串以拼音形式返回，存在多音字时会返回多个
    /// - Returns: ["nihaoa"]
    func transferPinyin() -> [String] {
         transferPinyinArrs().combineToString()
    }
    
    /// 返回给定字符串的拼音首字母，以数组的形式返回，存在多音字时会返回多个
    /// - Returns: [["n","h","a"]]
    func transferPinyinInitialArrs() -> [[String]] {
        var items: [[String]] = []
        for c in self {
            let cs = "\(c)"
            var initias = PinYinManager.shared.initialDic[cs]
            if initias == nil {
                initias = [cs]
            }
            items.append(initias!)
        }
        return items.combine()
    }
    
    /// 返回给定字符串的拼音首字母组合字符串数组，存在多音字时会返回多个
    /// - Returns: ["nha"]
    func transferPinyinInitial() -> [String] {
        transferPinyinInitialArrs().combineToString()
    }
    
    
    /// 是否为纯英文
    /// - Returns: 是：true，否：false
    func isPureEnglish() -> Bool {
        let regex = "[a-zA-Z]+"
        if let regular = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            let matchs = regular.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count))
            return matchs.count > 0
        }
        return false
    }
}



extension Array where Element == [String] {
    func combine() -> [[String]] {
        if self.isEmpty {
            return self
        }
        var results: [[String]] = []
        var oneRes: [String] = []
        _combineOne(with: &results, dindex: 0, oneRes: &oneRes)
        return results
    }
    
    private func _combineOne(with results: inout [[String]], dindex: Int, oneRes: inout [String]) {
        if dindex == self.count {
            results.append(oneRes)
            return
        }
        for obj in self[dindex] {
            oneRes.append(obj)
            _combineOne(with: &results, dindex: dindex + 1, oneRes: &oneRes)
            oneRes.removeLast()
        }
    }
    
    func combineToString() -> [String] {
        var results: [String] = []
        for all in self {
            var string = ""
            for s in all {
                string.append(s)
            }
            results.append(string)
        }
        return results
    }
}




