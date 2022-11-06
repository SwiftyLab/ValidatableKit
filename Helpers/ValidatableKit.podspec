require 'json'

Pod::Spec.new do |s|
  s.name              = 'ValidatableKit'
  s.module_name       = s.name

  require_relative 'spec'
  s.extend ValidatableKit::Spec
  s.common_spec
  s.file_spec
end
