class CreatePersonalSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :personal_schedules do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.datetime :started_at
      t.datetime :ended_at
      t.text :notes

      t.timestamps
    end
  end
end
