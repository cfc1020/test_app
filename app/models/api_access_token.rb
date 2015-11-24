# == Schema Information
#
# Table name: api_access_tokens
#
#  id         :integer          not null, primary key
#  token      :string(255)      not null
#  active     :boolean          not null
#  client_id  :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApiAccessToken < ActiveRecord::Base
  EXPIRATION_TIME = 12.hours
  INSTANCE_CODE   = 'testcost'
  BASE_API_URL    = 'platform161.com/api/'
  USERNAME        = 'test.api'
  PASSWORD        = '5DRX-AF-gc4'
  CLIENT_ID       = 'Test'
  CLIENT_SECRET   = 'xIpXeyMID9WC55en6Nuv0HOO5GNncHjeYW0t5yI5wpPIqEHV'

  validates_datetime :created_at, after: -> { EXPIRATION_TIME.ago }, allow_blank: true

  validates :client_id, :active, :token, presence: true
  validates :active, inclusion: { in: [true]}, allow_blank: true
  validates :client_id, :token, length: { in: 2..255 }, allow_blank: true

  def self.get_api_access_token
    api_access_token = ApiAccessToken.last

    return api_access_token.token if api_access_token.try :valid?

    ApiAccessToken.generate_api_access_token.try :token
  end

  # private

  def self.generate_api_access_token
    response = platform161_client.api_call :post, 'api/v2/access_tokens/'
    ## debug
    # p response

    create permitted_params(response.body)
  end

  def self.parse_response(response)
    JSON.parse(response).with_indifferent_access
  end

  def self.permitted_params(params)
    params.slice(*column_names)
  end

  def self.platform161_client
    @platform161_client ||= ApiClient::Platform161Client.new authentication: :api_credentials
  end

  # def self.conn
  #   @@conn ||= Faraday.new(url: api_url) do |faraday|
  #     # faraday.request  :multipart
  #     faraday.request  :url_encoded             # form-encode POST params
  #     faraday.response :logger                  # log requests to STDOUT
  #     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  #   end
  # end

  def self.api_url
    "https://#{INSTANCE_CODE}.#{BASE_API_URL}"
  end

  def self.api_authentication_url
    "#{api_url}/v2/access_tokens"
  end

  def self.credentials
    {
      user: USERNAME,
      password: PASSWORD,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET
    }
  end
end
