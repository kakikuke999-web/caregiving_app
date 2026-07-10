class MigrateAndRemoveEmergencyContact < ActiveRecord::Migration[7.1]
  def up
    CareRecipient.where.not(emergency_contact: [nil, ""]).find_each do |care_recipient|
      EmergencyContact.create!(
        care_recipient_id: care_recipient.id,
        name: "登録済みの連絡先",
        phone_number: care_recipient.emergency_contact,
        priority: 1
      )
    end

    remove_column :care_recipients, :emergency_contact, :string
  end

  def down
    add_column :care_recipients, :emergency_contact, :string
  end
end
