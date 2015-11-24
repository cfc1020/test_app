class AdvertiserReportItem < OpenStruct
  def initialize(attributes)
    super

    calculate_other_attributes!
  end

  def calculate_other_attributes!
    self[:ecpm] = ecpm
    self[:ecpc] = ecpc
    self[:ecpa] = ecpa
  end

  def self.build_from_array(items)
    items.map { |item| AdvertiserReportItem.new item }
  end

  def ecpm
    self[:gross_revenues].to_f / self[:impressions].to_f * 1_000
  end

  def ecpc
    self[:gross_revenues].to_f / self[:clicks].to_f
  end

  def ecpa
    self[:gross_revenues].to_f / self[:conversions].to_f
  end
end
