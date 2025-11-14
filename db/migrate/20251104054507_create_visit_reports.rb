class CreateVisitReports < ActiveRecord::Migration[7.1]
  def change
    create_table :visit_reports do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :notes
      t.datetime :visited_at

      t.timestamps
    end
  end
end
