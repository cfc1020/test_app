module ApiClient
  class Platform161Client
    DEFAULT_OPTIONS = {
      root_url: Rails.application.secrets.host_name
    }.freeze

    REQUEST_METHODS = %i(get post head options patch put delete).freeze

    attr_reader :options, :errors

    def initialize(options)
      process_options options
    end

    def api_call(method, url, params = {})
      raise NoMethodError, "undefined method `#{method}'" if REQUEST_METHODS.exclude? method.to_sym

      connection.send method, url, prepare_request_params(params), request_headers
    end

    protected

    def prepare_request_params(params)
      request_params.deep_merge(params)
    end

    def process_options(options)
      @options = DEFAULT_OPTIONS.deep_merge options

      set_authentication
    end

    def set_authentication
      case @options[:authentication]
      when :api_token
        @request_headers = request_headers.merge api_token
      when :api_credentials
        @request_params = request_params.merge api_credentials
      end
    end

    def api_token
      {
        'PFM161-API-AccessToken' => ApiAccessToken.get_api_access_token
      }
    end

    def api_credentials
      {
        user: Rails.application.secrets.user,
        password: Rails.application.secrets.password,
        client_id: Rails.application.secrets.client_id,
        client_secret: Rails.application.secrets.client_secret
      }
    end

    def request_params
      @request_params ||= {}
    end

    def request_headers
      @request_headers ||= {}
    end

    def connection
      @connection ||= Connection.new options
    end

    def reset_connection!
      @connection = nil
    end
  end
end
