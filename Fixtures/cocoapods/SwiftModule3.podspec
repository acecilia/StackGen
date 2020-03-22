Pod::Spec.new do |s|
  s.name                   = 'SwiftModule3'
  s.version                = '0.0.1'
  s.swift_version          = '5.0'
  s.ios.deployment_target  = '10.0'
  s.source_files           = 'Libraries/SwiftModule3/src/main/swift/*.swift'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Libraries/SwiftModule3/src/test/swift/*.swift'
  end

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
