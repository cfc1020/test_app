class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :advertiser_report_id, index: { unique: true }
      t.string  :comment
      t.integer :user_id, null: false, index: true
      t.string  :error_message
      t.integer :campaign_id, null: false
      t.text    :json_report

      t.timestamps null: false
    end
  end
end
