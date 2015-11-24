module ApiClient
  ErrorClass = Class.new(StandardError)

  # Base class for all specific exceptions
  # Resource Not Found, Resource Invalid and other
  class ResponseError < ErrorClass
    attr_reader :body, :env, :error, :method, :status, :url

    def initialize(env = {})
      if env.respond_to? :fetch
        @body = env.fetch(:body, {})
        @env = env
        @error = @body['error']
        @method = env[:method]
        @status = env[:status]
        @url = env[:url]
      end

      super(message)
    end

    def message
      @error
    end
  end

  class ParsingError < ResponseError
    def message
      "#{status} Error"
    end
  end

  ResourceNotFound = ActiveResource::ResourceNotFound
end
