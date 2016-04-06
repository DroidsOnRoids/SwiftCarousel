Pod::Spec.new do |s|
  s.name             = "SwiftCarousel"
  s.version          = "0.6"
  s.summary          = "Infinite carousel of options."
  s.description      = "SwiftCarousel is a fully native Swift UIScrollView wrapper, that allows you to infinite circular scroll with UIView objects."
  s.homepage         = "https://github.com/Sunshinejr/SwiftCarousel"
  s.license          = 'MIT'
  s.author           = { "Łukasz Mróz" => "lukasz.mroz@droidsonroids.pl" }
  s.source           = { :git => "https://github.com/DroidsOnRoids/SwiftCarousel.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thesunshinejr'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*.swift'
  s.frameworks = 'UIKit'
end
