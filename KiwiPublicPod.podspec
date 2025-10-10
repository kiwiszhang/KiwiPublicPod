#
# Be sure to run `pod lib lint KiwiPublicPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KiwiPublicPod'
  s.version          = '0.1.8'
  s.summary          = 'A short description of KiwiPublicPod.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kiwiszhang/KiwiPublicPod.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张志强' => 'zhangzhiqiang.mail@qq.com' }
  s.source           = { :git => 'https://github.com/kiwiszhang/KiwiPublicPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  # ✅ Pod 最低支持 iOS 15，
  s.ios.deployment_target = '15.0'

  # ✅ Swift 版本
  s.swift_versions   = '5'
  # 源码文件，保留 Classes 下的目录结构
  s.source_files = 'KiwiPublicPod/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit', '~> 5.6.0'
  s.dependency 'Localize-Swift', '~> 3.1.0'
  s.dependency 'MBProgressHUD', '~> 1.2.0'
  
  
  # 资源文件，递归保留 Assets 下所有子目录
  s.resource_bundles = {
    'KiwiPublicPod' => ['KiwiPublicPod/Assets/**/*']
  }
  
  s.preserve_paths = 'KiwiPublicPod/Classes/**/*', 'KiwiPublicPod/Assets/**/*'

end
