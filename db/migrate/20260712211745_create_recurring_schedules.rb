class CreateRecurringSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :recurring_schedules do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :visit_type, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time
      t.string :provider_name
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
