module AmazonEcommerce
  class AmazonQuery
    attr_accessor :request, :response_body, :response_hash, :products

    def initialize
      self.request = Vacuum.new('US', true)
      self.request.configure(
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['AWS_ASSOCIATE_TAG']
        )
    end

    def parse_errors errors
      if errors.is_a? Array
        errors.map do |error|
          error_message error
        end
      else
        [error_message(errors)]
      end
    end

    def error_message error
      { code: error["Code"], message: error["Message"] }
    end
  end
end
