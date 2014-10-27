require "send_s3_file/version"
require 'aws-sdk'
require "iconv"
require "active_support"
require "action_controller"


module SendS3File
  def send_s3_file file_name, bucket, options = {}
    s3 = AWS::S3.new
    object = s3.buckets[bucket].objects[file_name]
    headers.merge!(
        'Content-Type'              => build_content_type(options),
        'Content-Disposition'       => build_disposition(options),
        'Content-Transfer-Encoding' => 'binary'
    )

    render :status => options[:status], :text => Proc.new {|response, output|
      logger.info "Streaming file from s3 #{bucket} #{file_name}" unless logger.nil?
      object.read do |chunk|
        output.write(chunk)
      end
      logger.info "Done Streaming file from s3 #{bucket} #{file_name}" unless logger.nil?
    }
  end

  private
  def build_disposition(options)
     disposition = (options[:disposition] || 'attachment').dup
     disposition <<= %(; filename="#{options[:filename]}") if options[:filename]
     disposition
  end

  def build_content_type(options)
    content_type = options[:type]
    if content_type.is_a?(Symbol)
      raise ArgumentError, "Unknown MIME type #{options[:type]}" unless Mime::EXTENSION_LOOKUP.has_key?(content_type.to_s)
      content_type = Mime::Type.lookup_by_extension(content_type.to_s)
    end
    content_type = content_type.to_s.strip
  end
end

class ActionController::Base
  include SendS3File
end
