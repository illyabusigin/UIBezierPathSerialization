Pod::Spec.new do |s|
  s.name         =  'UIBezierPathSerialization'
  s.version      =  '1.0.0'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary      =  'Encode and decode between JSON and UIBezierPath objects'
  s.author       =  { 'Illya Busigin' => 'http://illyabusigin.com/' }
  s.source       =  { :git => 'ttps://github.com/illyabusigin/UIBezierPathSerialization.git', :tag => '1.0.0' }
  s.homepage     =  'https://github.com/illyabusigin/UIBezierPathSerialization'
  s.platform     =  :ios
  s.source_files =  'UIBezierPathSerialization'
  s.frameworks   =  'CoreGraphics'
  s.requires_arc =  true
  s.ios.deployment_target = '6.0'
end
