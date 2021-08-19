# IASearchKit

### 介绍
* 支持精确搜索、拼音首字母搜索、全拼搜索
* 支持关键字识别，多个关键字识别

### 效果图
![image](https://github.com/CranzCapatain/IASearchKit/blob/master/Search.gif)


### cocoapods 安装
`gem install cocoapods`

### Podfile
`pod 'IASearchKit', '~> 1.1.0'`

或者直接：
`pod 'IASearchKit'`

Then
`pod install`



### SearchKit文件描述
* IAUni2Pinyin.txt
这个文件记录着所有中文的uncoide及其对应的多音字（⚠️ **不要去修改这个文件下的东西** ）
* IAPinYinHelper
这个 Helper 类提供了一些转换字符串到拼音的便利方法
* IAPinYinManager
单例类，这里有个api`loadPinyinData`需要在合适的时候去调用，它会把**IAUni2Pinyin**文件中的内容读取到内存中去
* NSString+Search
这个分类用于搜索关键字或者拼音匹配识别，一般用这个类里的方法就够了
* NSArray+Combine
工具类，不多介绍...

### 使用
下面方法就是拼音匹配的用法：

```
NSRange range;
BOOL match = [self.textLabel.text canMatchWithKeyword:searchText range:&range];
if (match) {

}
```

### 更新记录
* **1.1.0** ：修复bug，这个bug会导致输入英文字母无法识别其大写形式。

### 许可证
This project is licensed under the terms of the MIT license. See the [LICENSE](https://github.com/CranzCapatain/IASearchKit/blob/master/LICENSE) file.

> This project and all fastlane tools are in no way affiliated with Apple Inc. This project is open source under the MIT license, which means you have full access to the source code and can modify it to fit your own needs. All fastlane tools run on your own computer or server, so your credentials or other sensitive information will never leave your own computer. You are responsible for how you use fastlane tools.
