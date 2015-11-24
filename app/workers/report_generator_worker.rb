class ReportGeneratorWorker
  include Sidekiq::Worker

  def perform(report_id)
    begin
      create_base_variables report_id
      report_template = ReportTemplate.new(@campaign, @advertiser_report_items, @report)
      PdfGenerators::ReportPdfGenerator.new(report_template).generate!
      @report.update_attribute :advertiser_report_id, @advertiser_report.id
    rescue ApiClient::ResourceNotFound => e
      @report.update_attribute :error_message, e.message
    end
  end

  protected

  def create_base_variables(report_id)
    @report = Report.find report_id
    @campaign = Campaign.find(@report.campaign_id)
    @advertiser_report = create_advertiser_report
    @advertiser_report_items = proccess_advertiser_report
  end

  def proccess_advertiser_report
    # HACK: custom filter by campaign_id
    items = @advertiser_report.results.select { |item| item.campaign_id == @campaign.id }

    AdvertiserReportItem.build_from_array items.map(&:attributes)
  end

  def create_advertiser_report
    AdvertiserReport.create params_for_create_advertiser_report
    # AdvertiserReport API request doesn't work with a filters(by ids)
  end

  def params_for_create_advertiser_report
    {
      advertiser_report: {
        # doesn't matter, because they don't provide through api(for example, gross_revenues)
        # measures: ["impressions", "clicks", "conversions", "media_spent", "gross_revenues"],
        interval: :daily,
        # because reports excludes current_campaign
        # date_limit: :range,
        # start_on: @campaign.start_on,
        # end_on: @campaign.end_on,
        # HACK
        period: :last_30_days,
        # groupings: [:campaign, :creative]
        groupings: [:campaign]
      }
    }
  end
end
