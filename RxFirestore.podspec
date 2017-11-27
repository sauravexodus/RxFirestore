#
# Be sure to run `pod lib lint RxFirestore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxFirestore'
  s.version          = '0.1.0'
  s.summary          = 'Reactive extensions for Firebase Firestore | Swift 4.0 Compatible'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Reactive X wrappers for Firestore.
                       DESC

  s.homepage         = 'git@github.com:sauravexodus/RxFirestore.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sauravexodus' => 'saurav.chandra1992@live.com' }
  s.source           = { :git => 'https://github.com/sauravexodus/RxFirestore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxFirestore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RxFirestore' => ['RxFirestore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Firebase/Firestore'
  s.dependency 'RxSwift'
end
