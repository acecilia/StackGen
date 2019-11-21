Pod::Spec.new do |s|
  s.name                   = 'SwiftModule'
  s.version                = '1.0.0'
  s.source_files           = 'Libraries/SwiftModule/src/main/swift/*.swift'

  spec.dependency 'SwiftModule2', '1.0.0'

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
