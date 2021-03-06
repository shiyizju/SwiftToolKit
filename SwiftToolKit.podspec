Pod::Spec.new do |spec|
  spec.name         = 'SwiftToolKit'
  spec.version      = '0.0.2'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/shiyizju/SwiftToolKit'
  spec.authors      = { 'Quan Xiaosha' => 'quanxiaosha@gmail.com' }
  spec.summary      = 'Swift tooks like algorithm and persistent store'
  spec.source       = { :git => 'https://github.com/shiyizju/SwiftToolKit.git', :tag => "v#{spec.version.to_s}" }
  spec.source_files = 'Sources/*', 'Sources/Algorithm/*', 'Sources/Persistent/*', 'Sources/Persistent/Cached/*'
  spec.requires_arc = true
  spec.dependency 'FMDB'
end
