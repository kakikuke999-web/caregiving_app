class CreateCareRecipientVisitTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :care_recipient_visit_types do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :visit_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
