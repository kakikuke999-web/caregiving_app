class AddServiceUsageSlipFieldsToCareRecipients < ActiveRecord::Migration[7.1]
  def change
    add_column :care_recipients, :name_kana, :string
    add_column :care_recipients, :insurer_number, :string
    add_column :care_recipients, :insured_person_number, :string
    add_column :care_recipients, :benefit_limit_units, :integer
  end
end
