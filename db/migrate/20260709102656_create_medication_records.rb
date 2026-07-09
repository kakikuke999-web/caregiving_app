class CreateMedicationRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_records do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.datetime :recorded_at
      t.string :medication_name
      t.boolean :taken, null: false, default: true
      t.text :note

      t.timestamps
    end
  end
end
