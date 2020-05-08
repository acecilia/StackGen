Pod::Spec.new do |s|
  s.name                   = '{{module.name}}'
  s.version                = '{{custom.moduleVersion}}'
  s.swift_version          = '{{custom.swiftVersion}}'
  s.ios.deployment_target  = '{{custom.minimumDeploymentTarget}}'
  s.source_files           = '{{module.location.path}}/src/main/swift/*.swift'
  s.static_framework       = true
  {% if module.dependencies.main|default:"" %}

  {% endif %}
  {% for dependency in module.dependencies.main|default:"" %}
  {% if dependency.kind == "firstParty" %}
  s.dependency '{{dependency.name}}', '{{custom.moduleVersion}}'
  {% elif dependency.kind == "thirdParty" %}
  s.dependency '{{dependency.name}}', '{{dependency.version}}'
  {% endif %}
  {% endfor %}

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = '{{module.location.path}}/src/test/swift/*.swift'
    {% if module.dependencies.test|default:"" %}

    {% endif %}
    {% for dependency in module.dependencies.test|default:"" %}
    {% if dependency.kind == "firstParty" %}
    test_spec.dependency '{{dependency.name}}', '{{custom.moduleVersion}}'
    {% elif dependency.kind == "thirdParty" %}
    test_spec.dependency '{{dependency.name}}', '{{dependency.version}}'
    {% endif %}
    {% endfor %}
  end

  # Dummy data required by cocoapods
  s.authors                = 'dummy'
  s.summary                = 'dummy'
  s.homepage               = 'dummy'
  s.license                = { :type => 'MIT' }
  s.source                 = { :git => '' }
end
