class CreateSupportLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :support_logs do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :occurred_at
      t.string :category
      t.text :body

      t.timestamps
    end
  end
end
