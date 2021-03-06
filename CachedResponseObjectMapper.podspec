#
# Be sure to run `pod lib lint CachedResponseObjectMapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CachedResponseObjectMapper"
  s.version          = "1.0.0"
  s.summary          = "Mapper the cached responce Json to object"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  Mapper the cached responce Json to object that caches using NSURLCache
                       DESC

  s.homepage         = "https://github.com/dimohamdy/CachedResponseObjectMapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "dimohamdy" => "dimo.hamdy@gmail.com" }
  s.source           = { :git => "https://github.com/dimohamdy/CachedResponseObjectMapper.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/dimohamdy'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  #s.resource_bundles = ''

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'ObjectMapper', '~> 1.1'
end
