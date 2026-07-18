class CreateCarePlanServices < ActiveRecord::Migration[7.1]
  def change
    create_table :care_plan_services do |t|
      t.references :care_plan_goal, null: false, foreign_key: true
      t.text :content
      t.string :category
      t.string :provider
      t.string :frequency
      t.string :period
      t.integer :position

      t.timestamps
    end
  end
end
