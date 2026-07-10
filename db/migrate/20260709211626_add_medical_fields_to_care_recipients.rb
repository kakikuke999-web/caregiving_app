class AddMedicalFieldsToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :medical_history, :text
    add_column :care_recipients, :primary_doctor, :string
    add_column :care_recipients, :primary_hospital, :string
    add_column :care_recipients, :regular_medications, :text
  end
end
