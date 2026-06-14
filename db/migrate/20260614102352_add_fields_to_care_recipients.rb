class AddFieldsToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :birthday, :date
    # add_column :care_recipients, :address, :string
    # add_column :care_recipients, :care_level, :string
    add_column :care_recipients, :memo, :text
  end
end
