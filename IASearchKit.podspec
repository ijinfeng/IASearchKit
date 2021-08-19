#
#  Be sure to run `pod spec lint IASearchKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "IASearchKit"
  s.version      = '1.1.1'
  s.summary      = "search kit for iOS write by Objective-C"
  s.description  = <<-DESC
			SearchKit support Chinese search, pinyin initials, full spelling.
                   DESC
  s.homepage     = "https://github.com/CranzCapatain/IASearchKit.git"

  s.license          = 'MIT'

  s.author             = { "Alter" => "1154941292@qq.com" }

  s.platform     = :ios
  s.source       = { :git => "https://github.com/CranzCapatain/IASearchKit.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = 'SearchKit/SearchKit/*.{h,m}'
s.resources = 'SearchKit/SearchKit/*.txt'


end
