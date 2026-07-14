class AddGenderToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :gender, :string
  end
end
