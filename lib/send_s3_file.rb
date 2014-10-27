require "send_s3_file/version"
require 'aws-sdk'
require "iconv"
require "active_support"
require "action_controller"


module SendS3File
  def send_s3_file s3_object, options = {}
    headers.merge!(
        'Content-Type'              => build_content_type(options),
        'Content-Disposition'       => build_disposition(options),
        'Content-Transfer-Encoding' => 'binary'
    )

    render :status => options[:status], :text => Proc.new {|response, output|
      logger.info "Streaming file from s3 #{s3_object.bucket} #{s3_object.key}" unless logger.nil?
      s3_object.read do |chunk|
        output.write(chunk)
      end
      logger.info "Done Streaming file from s3 #{s3_object.bucket} #{s3_object.key}" unless logger.nil?
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
