module ReportsHelper
  def report_field_average(advertiser_report_results, field)
    fields = advertiser_report_results.map { |item| item[field].to_f }

    field.inject(:+) / fields.count rescue 0.0
  end

  def field_split_by_day(advertiser_report_results, field)
    [
      name: field.to_s,
      data: field_per_day(advertiser_report_results, field)
    ]
  end

  def feild_vs_field(advertiser_report_results, field1, field2)
    [
      field_split_by_day(advertiser_report_results, field1).first,
      field_split_by_day(advertiser_report_results, field2).first
    ]
  end

  def field_per_day(advertiser_report_results, field)
    advertiser_report_results.map { |item| [DateTime.parse(item.date), item[field]] }.to_h
  end
end
