Pod::Spec.new do |s|
  s.name                   = 'SwiftModule1'
  s.version                = '0.0.1'
  s.swift_version          = '5.0'
  s.ios.deployment_target  = '13.0'
  s.source_files           = 'Libraries/SwiftModule1/src/main/swift/*.swift'
  s.static_framework       = true

  s.dependency 'SwiftModule2', '0.0.1'
  s.dependency 'SnapKit', '5.0.1'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Libraries/SwiftModule1/src/test/swift/*.swift'

    test_spec.dependency 'SwiftModule3', '0.0.1'
  end

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
