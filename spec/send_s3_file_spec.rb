require 'spec_helper'

class TestController < ActionController::Base
  attr_reader :headers
  def initialize filename, bucketname, options, headers
    @filename = filename
    @bucketname = bucketname
    @options = options
    @headers = headers
  end

  def download_file
    send_s3_file @filename, @bucketname, @options
  end
end
describe SendS3File do
  it "downloads content from s3" do
    controller = TestController.new("large_file", "large_file_bucket", {}, {})
    controller.download_file


  end
end
