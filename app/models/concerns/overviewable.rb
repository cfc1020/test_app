module Overviewable
  extend ActiveSupport::Concern

  included do
    after_initialize :get_overview
  end

  def get_overview
  end
end
