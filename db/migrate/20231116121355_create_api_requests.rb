class CreateApiRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :api_requests do |t|
      t.string :request_method
      t.string :endpoint
      t.json :parameters
      t.string :error_message

      t.datetime :created_at, null: false
    end
  end
end
