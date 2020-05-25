#
# Be sure to run `pod lib lint QSDatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QSDatePicker'
  s.version          = '0.1.4'
  s.summary          = 'A handy swift time selector.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/1217119141/QSDatePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qianshuai' => '1217119141@qq.com' }
  s.platform         = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.source           = { :git => 'https://github.com/1217119141/QSDatePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.source_files = 'QSDatePicker/Classes/*'
  
  # s.resource_bundles = {
  #   'QSDatePicker' => ['QSDatePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
