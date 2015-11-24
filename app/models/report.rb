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

class Report < ActiveRecord::Base
  BASE_PATH_TO_REPORTS = Rails.root.join('public', 'reports')
  PDF_REPORT_NAME = 'advertiser_report_%s.pdf'

  validates :user_id, presence: true
  validates :advertiser_report_id, uniqueness: true, allow_blank: true
  validates :comment, length: { in: 0..160 }, allow_blank: true

  belongs_to :user

  after_commit :generate_report!, on: :create

  serialize :json_report, Hash

  scope :for_user, ->(user) { where(user: user) }

  # Probably it would be nice to connect this two entities (Report and AdvertiserReport).

  def generated?
    advertiser_report_id.present? && File.exist?(path_to_pdf_report)
  end

  def generate_report!
    return if generated?

    ReportGeneratorWorker.perform_async(id)
  end

  def path_to_pdf_report
    BASE_PATH_TO_REPORTS.join pdf_report_name
  end

  def pdf_report_name
    PDF_REPORT_NAME % id
  end
end
