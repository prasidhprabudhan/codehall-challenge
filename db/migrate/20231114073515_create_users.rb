class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :college, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name
      t.string :phone_number
      t.datetime :start_time

      t.timestamps
    end
  end
end
