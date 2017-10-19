Pod::Spec.new do |s|
  s.name             = 'flow-test'
  s.version          = '0.1.0'
  s.summary          = ' A pod to unit-test non-UI flow based on method selectors strings'
  s.description      = <<-DESC
A pod to unit-test non-UI flow based on method selectors strings.


When writing unit-tests for non-UI parts of an app, say like some kind of local in-memory store, for some scenarios, where there could be multiple ways of arriving at the same final result, basic unit-tests seem insufficient.

`flow-test` makes it explicit that for a particular test, a certain list of methods need to be called, in a particular order, for it to be successful.
                       DESC

  s.homepage         = 'https://github.com/gnithin/flow-test'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gnithin' => 'nithin.linkin@gmail.com' }
  s.source           = { :git => 'https://github.com/gnithin/flow-test.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'flow-test/Classes/**/*'
  s.frameworks = 'XCTest'
  s.dependency 'Aspects', '1.3.1'

  # This is for an issue where XCTest does not contain bit-code. So the whole pod needs to be like this
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
