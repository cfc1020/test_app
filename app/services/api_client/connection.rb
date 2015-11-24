module ApiClient
  class Connection < SimpleDelegator
    attr_reader :options

    DEFAULT_OPTIONS = {
      logger:      :logger,                # form-encode POST params
      url_encoded: :url_encoded,           # log requests to STDOUT
      adapter:     Faraday.default_adapter # make requests with Net::HTTP
    }.freeze

    def initialize(options = {})
      process_options(options)

      connection = Faraday.new(url: options[:root_url]) do |faraday|
        default_configure(faraday)
        configure_authentication(faraday)
        configure_cache(faraday)
        faraday.use :instrumentation
      end

      super(connection)
    end

    private

    def process_options(options)
      @options = DEFAULT_OPTIONS.deep_merge options
    end

    def default_configure(faraday)
      faraday.request  options[:url_encoded]
      faraday.response :hal_json
      faraday.response options[:logger]
      faraday.adapter  options[:adapter]
    end

    def configure_authentication(faraday)
      # we can't use it
      # use_token_authentication(faraday) if options[:api_token]
      # use_basic_authentication(faraday) if options[:username]
    end

    def use_token_authentication(faraday)
      faraday.request :token_auth, options[:api_token]
    end

    def use_basic_authentication(faraday)
      faraday.request :basic_auth, options[:username], options[:password]
    end

    def configure_cache(faraday)
      # case options[:cache]
      # when :rack then use_rack_cache(faraday)
      # when :rails then use_rails_cache(faraday)
      # end
    end

    def use_rack_cache(faraday)
      # do something
    end

    def use_rails_cache(faraday)
      # do something
    end
  end
end
