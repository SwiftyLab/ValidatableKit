Pod::Spec.new do |s|
  s.name              = 'ValidatableKit'
  s.module_name       = s.name

  require_relative 'Helpers/spec'
  s.extend ValidatableKit::Spec
  s.common_spec
  s.file_spec

  s.test_spec do |ts|
    ts.source_files = "Tests/#{s.module_name}Tests/**/*.swift"
  end
end
