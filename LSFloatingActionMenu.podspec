Pod::Spec.new do |s|
  s.name     = 'LSFloatingActionMenu'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'LSFloatingActionMenu is floating action button component of material design for iOS.'
  s.homepage = 'https://github.com/tinymind/LSFloatingActionMenu'
  s.author   = { "tinymind" => "xappbox@gmail.com" }
  s.source   = { :git => 'https://github.com/tinymind/LSFloatingActionMenu.git', :tag => s.version.to_s}
  s.platform = :ios, '7.0'
  s.requires_arc = true  
  
  s.source_files = 'LSFloatingActionMenu/*'
  s.frameworks = 'Foundation', 'UIKit'
end