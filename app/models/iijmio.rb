# frozen_string_literal: true

class Iijmio < ActiveRecord::Base
  def self.csv_attributes
    %w[day lte_data restricted_data email created_at updated_at]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |record|
        csv << csv_attributes.map { |attr| record.send(attr) }
      end
    end
  end

  def self.crawl(email)
    @items = Tasks::Iijmio.crawl
    update_usage(@items['usage'], email)
  end

  def self.crawl_rest_log(email)
    @items = Tasks::Iijmio.get_rest_api(%(/mobile/d/v1/log/packet/), email)
    packet_log = @items['packetLogInfo'][0]['hdoInfo'].first['packetLog']
    update_usage(packet_log, email)
  end

  def self.update_usage(usage, email)
    items_usage = inject_usage(usage, email)
    Iijmio.import items_usage, on_duplicate_key_update: {
      conflict_target: %i[email day], columns: %i[lte_data restricted_data]
    }
  end

  def self.inject_usage(usage, email)
    usage.inject([]) do |result, x|
      result << Iijmio.new(
        day: x['date'], email: email,
        lte_data: x['withCoupon'],
        restricted_data: x['withoutCoupon'],
        # email: email,
        created_at: Time.now,
        updated_at: Time.now
      )
    end
  end
end
