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
  API_URL = 'api/v2/access_tokens/'

  validates_datetime :created_at, after: -> { EXPIRATION_TIME.ago }, allow_blank: true

  validates :client_id, :active, :token, presence: true
  validates :active, inclusion: { in: [true]}, allow_blank: true
  validates :client_id, :token, length: { in: 2..255 }, allow_blank: true

  def self.get_api_access_token
    api_access_token = ApiAccessToken.last

    return api_access_token.token if api_access_token.try :valid?

    ApiAccessToken.generate_api_access_token.try :token
  end

  private

  def self.generate_api_access_token
    response = platform161_client.api_call :post, API_URL
    ## debug
    # p response

    create permitted_params(response.body)
  end

  def self.permitted_params(params)
    params.slice(*column_names)
  end

  # maybe need to move to concerns
  def self.platform161_client
    @platform161_client ||= ApiClient::Platform161Client.new authentication: :api_credentials
  end
end
