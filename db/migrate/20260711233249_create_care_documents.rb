class CreateCareDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :care_documents do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.references :uploaded_by, null: false, foreign_key: { to_table: :users }
      t.string :document_type, null: false
      t.string :title
      t.string :issuing_organization
      t.date :issued_on
      t.date :valid_from
      t.date :valid_until
      t.text :note

      t.timestamps
    end
  end
end
