class CreateAdlRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :adl_records do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.datetime :recorded_at
      t.integer :meal_intake
      t.integer :excretion_status
      t.integer :sleep_quality
      t.text :note

      t.timestamps
    end
  end
end
