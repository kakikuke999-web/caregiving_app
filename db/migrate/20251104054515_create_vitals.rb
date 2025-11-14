class CreateVitals < ActiveRecord::Migration[7.1]
  def change
    create_table :vitals do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.datetime :recorded_at
      t.string :type
      t.string :value

      t.timestamps
    end
  end
end
