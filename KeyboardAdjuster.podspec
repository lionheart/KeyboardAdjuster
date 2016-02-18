Pod::Spec.new do |s|
  s.name             = "KeyboardAdjuster"
  s.version          = "0.1.0"
  s.summary          = "Automatically resizes and adjust views to scroll when a keyboard appears."
  s.homepage         = "https://github.com/lionheart/KeyboardAdjuster"
  s.license          = 'Apache 2.0'
  s.author           = { "Dan Loewenherz" => "dan@lionheartsw.com" }
  s.source           = { :git => "https://github.com/lionheart/KeyboardAdjuster.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dwlz'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
