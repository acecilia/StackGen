Pod::Spec.new do |s|
  s.name                   = 'SwiftModule3'
  s.version                = '0.0.1'
  s.swift_version          = '5.0'
  s.source_files           = 'src/main/swift/*.swift'

  spec.dependency 'FileKit', '6.0.0'

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
