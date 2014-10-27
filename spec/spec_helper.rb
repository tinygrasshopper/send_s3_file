require 'bundler/setup'
Bundler.setup

require 'send_s3_file'
require 'aws-sdk'

RSpec.configure do |config|
  AWS.stub!
end
