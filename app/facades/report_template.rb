class ReportTemplate
  attr_reader :campaign, :advertiser_report_items, :report

  def initialize(campaign, advertiser_report_items, report)
    @campaign, @advertiser_report_items, @report = campaign, advertiser_report_items, report
  end

  def advertiser_report_items_group_by_date
    @advertiser_report_items_group_by_campaign_and_day ||= advertiser_report_items.group_by(&:date)
  end

  def 

  def creatives
    # It's unclear how to deal with the following error: interrupt and repeat everything or skip
    campaign.creatives rescue nil # skip
  end
end
