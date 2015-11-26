require 'active_resource'

class Campaign < ActiveResource::Base
  include Platform161Clientable

  attr_accessor :total_campaign_cost, :sales_manager

  has_many :creatives
  belongs_to :sales_manager

  # Probably it would be nice to add validations.
end
