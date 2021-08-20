//
//  PinYinManager.swift
//  KeySearch
//
//  Created by jinfeng on 2021/8/19.
//

import Foundation

public class PinYinManager: NSObject {
    
    @objc public static let shared = PinYinManager()
        
    @objc public private(set) var pinyinDic: [String: [String]] = [:]
    
    @objc public private(set) var initialDic: [String: [String]] = [:]
    
    private override init() { super.init() }
    
    @objc public func loadPinyinData() {
        if hasLoaded {
            return
        }
        hasLoaded = true
        
        var resourcePath = Bundle(for: PinYinManager.self).resourcePath
        resourcePath?.append("/IAUni2Pinyin.txt")
        
        guard let dataPath = resourcePath else {
            print("path of 'IAUni2Pinyin.txt' is invalid")
            return
        }
        
        guard let readHandler = FileHandle.init(forReadingAtPath: dataPath) else {
            print("init fileHandler failed with dataPath=\(dataPath)")
            return
        }
        guard var readString = String(data: readHandler.availableData, encoding: .utf8) else {
            print("read string from dataPath=\(dataPath) is invalid")
            return
        }
        readString = readString.replacingOccurrences(of: " ", with: "")
        
        let pitchs: [Character] = ["0", "1", "2", "3", "4", "5"]
        let unicodeLineArr = readString.components(separatedBy: "\n")
        for unicodeLine in unicodeLineArr {
            let unicodeValues = unicodeLine.components(separatedBy: "\t")
            let unicode = unicodeValues[0]
            let pinyins = unicodeValues[1..<unicodeValues.count]
            
            var _pinyins: [String] = []
            var _initials: [String] = []
            for pinyin in pinyins {
                let pitch = pinyin.last
                if pitchs.contains(pitch!) {
                    let p = pinyin["".startIndex..<pinyin.index(pinyin.endIndex, offsetBy: -1)]
                    _pinyins.append(String(p))
                } else {
                    _pinyins.append(pinyin)
                }
                let initial = pinyin["".startIndex..<pinyin.index(after: "".startIndex)]
                _initials.append(String(initial))
            }
            let key = replaceUnicode(from: "\\u\(unicode)")
            pinyinDic[key] = _pinyins
            initialDic[key] = _initials
        }
    }
    
    private var hasLoaded = false
    
    
    
    private func replaceUnicode(from unicodeStr: String) -> String {
        let tempStr1 = unicodeStr.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: .utf8)
        guard let data = tempData else {
            return ""
        }
        if #available(iOS 9.0, *) {
            return try! PropertyListSerialization.propertyList(from: data, format: nil) as! String
        } else {
            return PropertyListSerialization.propertyListFromData(data, format: nil, errorDescription: nil) as! String
        }
    }
    
}
