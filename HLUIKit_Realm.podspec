#
# Be sure to run `pod lib lint HLUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLUIKit_Realm'
  s.version          = '1.0.1'
  s.summary          = '基于RxSwift的界面库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HLUIKit Realm数据库封装
                       DESC

  s.homepage         = 'https://github.com/U131025/HLUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mojy' => 'mojingyufly@163.com' }
  s.source           = { :git => 'https://github.com/U131025/HLUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'HLUIKit/Extension/RealmHelper/**/*'
  s.requires_arc = true

  s.dependency 'RealmSwift'
  s.dependency 'RxSwift', '~> 6.2.0'
  s.dependency 'RxCocoa', '~> 6.2.0'

end
