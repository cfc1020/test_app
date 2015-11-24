require 'active_resource'

class SalesManager < ActiveResource::Base
  include Platform161Clientable

  has_one :campaign
end
