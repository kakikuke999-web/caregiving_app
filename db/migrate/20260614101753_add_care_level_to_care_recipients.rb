class AddCareLevelToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :care_level, :string
  end
end
