# == Schema Information
#
# Table name: reports
#
#  id                   :integer          not null, primary key
#  advertiser_report_id :integer
#  comment              :string(255)
#  user_id              :integer          not null
#  error_message        :string(255)
#  campaign_id          :integer          not null
#  json_report          :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ReportSerializer < ActiveModel::Serializer
  attributes :id, :json_report, :campaign_id, :error_message, :created_at, :user_id, :comment
end
