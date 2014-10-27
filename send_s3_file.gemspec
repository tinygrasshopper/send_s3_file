# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'send_s3_file/version'

Gem::Specification.new do |spec|
  spec.name          = "send_s3_file"
  spec.version       = SendS3File::VERSION
  spec.authors       = ["Jatin Naik"]
  spec.email         = ["jsnaik@gmail.com"]
  spec.summary       = "Send file from s3 file"
  spec.description   = "Send file from s3 file"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack", "2.3.18"
  spec.add_dependency "aws-sdk"
  spec.add_dependency "iconv", "1.0.4"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails", "1.3.4"
end
