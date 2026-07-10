class CreateEmergencyContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :emergency_contacts do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.string :name
      t.string :relationship
      t.string :phone_number
      t.integer :priority, default: 1, null: false
      t.text :note

      t.timestamps
    end
  end
end
