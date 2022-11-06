require 'json'

module ValidatableKit
  module Spec
    def common_spec
      package = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

      self.version           = package.version.to_s
      self.homepage          = package.homepage
      self.summary           = package.summary
      self.description       = package.description
      self.license           = { :type => package.license, :file => 'LICENSE' }
      self.social_media_url  = package.author.url
      self.readme            = "#{self.homepage}/blob/main/README.md"
      self.changelog         = "#{self.homepage}/blob/main/CHANGELOG.md"

      self.source            = {
        package.repository.type.to_sym => package.repository.url,
        :tag => "v#{self.version}"
      }

      self.authors           = {
        package.author.name => package.author.email
      }

      self.swift_version = '5.0'
      self.ios.deployment_target = '8.0'
      self.macos.deployment_target = '10.10'
      self.tvos.deployment_target = '9.0'
      self.watchos.deployment_target = '2.0'
      self.osx.deployment_target = '10.10'
    end

    def file_spec
      self.documentation_url = "https://swiftylab.github.io/ValidatableKit/#{self.version}/documentation/#{self.module_name.downcase}/"
      self.source_files = "Sources/#{self.module_name}/**/*.swift", "Sources/#{self.module_name}/*.docc"
      self.preserve_paths = "Sources/#{self.module_name}/**/*", "*.md"
      # @todo: Enable when CocoaPods starts supporting docc
      # s.source_files = "#{s.module_name}.docc"
    end
  end
end