#
#  Be sure to run `pod spec lint STMRecord.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "STMRecord"
  s.version      = "1.1.0"
  s.summary      = "鸭子模型"
  s.homepage     = "https://github.com/DouKing/STMRecord"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wyk8916@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DouKing/STMRecord.git", :tag => "#{s.version}" }
  s.source_files = "STMRecord/Source", "STMRecord/Source/**/*.{h,m}"
  s.requires_arc = true

end
