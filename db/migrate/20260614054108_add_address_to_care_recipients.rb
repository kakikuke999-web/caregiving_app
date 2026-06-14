class AddAddressToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :address, :string
  end
end
