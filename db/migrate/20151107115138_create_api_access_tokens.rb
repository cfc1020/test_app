class CreateApiAccessTokens < ActiveRecord::Migration
  def change
    create_table :api_access_tokens do |t|
      t.string :token, null: false
      t.boolean :active, null: false
      t.string :client_id, null: false

      t.timestamps null: false
    end
  end
end
