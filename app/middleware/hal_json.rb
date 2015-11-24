require 'faraday_middleware/response_middleware'

module Middleware
  class HalJson < FaradayMiddleware::ParseJson
    def process_response(env)
      super
      ActiveResource::ResourceNotFound if env[:status] == 404
      # ApiClient::ResourceNotFound if env[:status] == 404
      case env[:status]
      when 500...599
        # raise ApiClient::ResponseError.new(env)
      when 400...499
        # raise ApiClient::ResponseError.new(env)
      end
    rescue Faraday::Error::ParsingError => err
      # raise ApiClient::ParsingError.new(env)
    end
  end
end
