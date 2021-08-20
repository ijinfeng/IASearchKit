//
//  KeySearch.swift
//  KeySearch
//
//  Created by jinfeng on 2021/8/20.
//

import Foundation

public extension String {
    func getRanges(with keyword: String?) -> [Range<Index>] {
        guard let keyword = keyword else {
            return []
        }
        if self.isEmpty {
            return []
        }
        
        var ranges: [Range<Index>] = []
        var lastRange = self.range(of: self)!
        while true {
            guard let r = self.range(of: keyword, options: .literal, range: lastRange, locale: nil) else {
                break
            }
            let lowerBound = r.upperBound
            let upperBound = self.endIndex
            lastRange = lowerBound..<upperBound
            
            print("======r=\(self.rawRange(from: r)), last=\(self.rawRange(from: lastRange))")
            
            ranges.append(r)
        }
        
        for r in ranges {
            print("###r=\(self.rawRange(from: r))")
        }
        return ranges
    }
    
    func getRanges(with keywords: [String]) -> [String: [Range<Index>]] {
        var rangeDic: [String: [Range<Index>]] = [:]
        for keyword in keywords {
            let ranges = getRanges(with: keyword)
            rangeDic[keyword] = ranges
        }
        return rangeDic
    }

    @discardableResult func canMatch(with keyword: String?, range: inout Range<Index>) -> Bool {
        guard let keyword = keyword else {
            return false
        }
        guard keyword.count > 0 && self.count > 0 else {
            return false
        }
        
        let realKey = keyword.lowercased()
        
        // 精准匹配
        let r = self.lowercased().range(of: realKey)
        if r != nil {
            range = r!
            return true
        }
        
        // 拼音首字母
        let stringPinyinInitials = self.transferPinyinInitial()
        for stringPinyinInitial in stringPinyinInitials {
            if let r = stringPinyinInitial.lowercased().range(of: realKey) {
                range = r
                return true
            }
        }
        
        // 全拼
        let pinyins = self.transferPinyinArrs()
        let stringPinyins = pinyins.combineToString()
        for index in 0..<stringPinyins.count {
            let stringPinyin = stringPinyins[index]
            if var r = stringPinyin.lowercased().range(of: realKey) {
                let pinyin = pinyins[index]
                
                var _count = 0
                let count = pinyin.count
                var location = -1
                var length = 0
                
                for i in 0..<count {
                    let pinyinStr = pinyin[i]
                    _count += pinyinStr.count
                    
                    if stringPinyin.index(stringPinyin.startIndex, offsetBy: _count) > r.lowerBound && location == -1 {
                        location = i
                    }
                    if location >= 0 {
                        length += 1
                    }
                    if stringPinyin.index(stringPinyin.startIndex, offsetBy: _count) >= r.upperBound {
                        break
                    }
                }
                r = self.index(self.startIndex, offsetBy: location)..<self.index(self.startIndex, offsetBy: location+length)
                range = r
                return true
            }
        }
        
        return false
    }
    
    @discardableResult func canMatch(with keyword: String?, all ranges: inout [Range<Index>]) -> Bool {
        guard let keyword = keyword else {
            return false
        }
        guard keyword.count > 0 && self.count > 0 else {
            return false
        }
        
        let realKey = keyword.lowercased()
        
        // 精准匹配
        if  !realKey.isPureEnglish() {
            let rs = self.lowercased().getRanges(with: realKey)
            if rs.count > 0 {
                ranges = rs
                return true
            }
        }
        
        // 拼音首字母
        let stringPinyinInitials = self.transferPinyinInitial()
        for stringPinyinInitial in stringPinyinInitials {
            var rs = stringPinyinInitial.lowercased().getRanges(with: realKey)
            if rs.count > 0 {
                rs = self.exRanges(from: rs, rangeString: stringPinyinInitial)
                ranges = rs
                return true
            }
        }
        
        // 全拼
        let pinyins = self.transferPinyinArrs()
        let stringPinyins = pinyins.combineToString()
        for index in 0..<stringPinyins.count {
            let stringPinyin = stringPinyins[index]
            let rs = stringPinyin.lowercased().getRanges(with: realKey)
            var newRanges: [Range<Index>]?
            if rs.count > 0 {
                newRanges = []
                for r in rs {
                    let pinyin = pinyins[index]
                    
                    var _count = 0
                    let count = pinyin.count
                    var location = -1
                    var length = 0
                    
                    for i in 0..<count {
                        let pinyinStr = pinyin[i]
                        _count += pinyinStr.count
                        
                        if stringPinyin.index(stringPinyin.startIndex, offsetBy: _count) > r.lowerBound && location == -1 {
                            location = i
                        }
                        if location >= 0 {
                            length += 1
                        }
                        if stringPinyin.index(stringPinyin.startIndex, offsetBy: _count) >= r.upperBound {
                            break
                        }
                    }
                    let _r = self.index(self.startIndex, offsetBy: location)..<self.index(self.startIndex, offsetBy: location+length)
                    newRanges!.append(_r)
                }
            }
            if let newRanges = newRanges  {
                ranges = newRanges
                return true
            }
        }
        
        return false
    }
}



public extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        NSRange(range, in: self)
    }
    
    func rawRange(from range: Range<Index>) -> (loc: Int, len: Int) {
        let location = self.distance(from: self.startIndex, to: range.lowerBound)
        let length = self.distance(from: range.lowerBound, to: range.upperBound)
        return (location, length)
    }
    
    func exRange(from distance: (loc: Int, len: Int)) -> Range<Index> {
        let lowerBound = self.index(self.startIndex, offsetBy: distance.loc)
        let upperBound = self.index(self.startIndex, offsetBy: distance.loc + distance.len)
        return lowerBound..<upperBound
    }
    
    func exRanges(from ranges: [Range<Index>], rangeString: String) -> [Range<Index>] {
        var rs: [Range<Index>] = []
        for r in ranges {
            let distance = rangeString.rawRange(from: r)
            rs.append(exRange(from: distance))
        }
        return rs
    }
}
