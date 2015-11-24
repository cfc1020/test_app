module Platform161Clientable
  extend ActiveSupport::Concern

  included do
    self.site = Rails.application.secrets.host_name
    self.prefix = '/api/v2/'
    self.format = :json
    cattr_accessor :static_headers
    @@static_headers = {}
    self.static_headers = headers
  end

  class_methods do
    # Dynamically-Generated Headers for ActiveResource Requests
    def headers
      new_headers = static_headers.clone
      new_headers['PFM161-API-AccessToken'] = ApiAccessToken.get_api_access_token
      new_headers
    end
  end
end
