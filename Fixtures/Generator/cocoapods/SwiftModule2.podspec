Pod::Spec.new do |s|
  s.name                   = 'SwiftModule2'
  s.version                = '1.0.0'
  s.swift_version          = '5.1.0'
  s.source_files           = 'Libraries/SwiftModule2/src/main/swift/*.swift'

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
