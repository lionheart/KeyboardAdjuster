# vim: ft=ruby

Pod::Spec.new do |s|
  s.name             = "KeyboardAdjuster"
  s.version          =  "4.0.0"
  s.summary          = "Automatically resizes and adjust views to scroll when a keyboard appears."
  s.homepage         = "https://github.com/lionheart/KeyboardAdjuster"
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { "Dan Loewenherz" => "dan@lionheartsw.com" }
  s.source           = { :git => "https://github.com/lionheart/KeyboardAdjuster.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dwlz'
  s.documentation_url = 'https://code.lionheart.software/KeyboardAdjuster/'

  s.platform     = :ios, '9.3'
  s.requires_arc = true

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0'
  }
  s.swift_version = '5.0'

  s.source_files = 'Pod/Classes/**/*'
end
