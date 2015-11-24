module Platform161Clientable
  extend ActiveSupport::Concern

  included do
    self.site = Rails.application.secrets.host_name
    self.prefix = '/api/v2/'
    self.format = :json
    headers['PFM161-API-AccessToken'] = ApiAccessToken.get_api_access_token
  end
end
