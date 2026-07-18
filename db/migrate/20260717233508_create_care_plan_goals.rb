class CreateCarePlanGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :care_plan_goals do |t|
      t.references :care_plan, null: false, foreign_key: true
      t.text :issue
      t.text :long_term_goal
      t.string :long_term_goal_period
      t.text :short_term_goal
      t.string :short_term_goal_period
      t.integer :position

      t.timestamps
    end
  end
end
