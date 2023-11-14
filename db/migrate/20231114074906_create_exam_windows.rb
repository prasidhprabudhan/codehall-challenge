class CreateExamWindows < ActiveRecord::Migration[7.0]
  def change
    create_table :exam_windows do |t|
      t.references :exam, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
