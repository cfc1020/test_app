require 'active_resource'

class Creative < ActiveResource::Base
  include Platform161Clientable

  belongs_to :campaign
end
