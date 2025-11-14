class CreateCareRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :care_recipients do |t|
      t.string :name
      t.date :dob
      t.string :emergency_contact
      t.text :allergies

      t.timestamps
    end
  end
end
