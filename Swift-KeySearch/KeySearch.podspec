#
# Be sure to run `pod lib lint KeySearch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KeySearch'
  s.version          = '0.1.1'
  s.summary          = 'Keyword search lib'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Keyword search, support Chinese and English, full spell, pinyin first letter.
                       DESC

  s.homepage         = 'https://github.com/ijinfeng/KeySearch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ijinfeng' => '851406283@qq.com' }
  s.source           = { :git => 'https://github.com/ijinfeng/KeySearch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Swift-KeySearch/KeySearch/Classes/**/*'
  s.resources = 'KeySearch/Assets/*.txt'
  
#   s.resource_bundles = {
#     'KeySearch' => ['KeySearch/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
