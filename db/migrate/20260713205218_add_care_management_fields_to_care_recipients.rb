class AddCareManagementFieldsToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_reference :care_recipients, :primary_care_manager, null: true, foreign_key: { to_table: :users }
    add_column :care_recipients, :care_level_valid_until, :date
  end
end
