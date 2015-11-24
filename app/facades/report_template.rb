class ReportTemplate
  attr_reader :campaign, :advertiser_report_items, :report

  def initialize(campaign, advertiser_report_items, report)
    @campaign, @advertiser_report_items, @report = campaign, advertiser_report_items, report
  end

  def advertiser_report_items_group_by_date
    @advertiser_report_items_group_by_campaign_and_day ||= advertiser_report_items.group_by(&:date)
  end

  # for all fields :)
  def campaign_totals
    @campaign_totals ||= advertiser_report_items.inject({}) do |memory, advertiser_report_item|
      advertiser_report_item.to_h.each do |key, value|
        memory[key] ||= 0.0
        memory[key] += value.to_f
      end

      memory
    end
  end

  def creatives
    # It's unclear how to deal with the following error: interrupt and repeat everything or skip
    campaign.creatives rescue nil # skip
  end
end
