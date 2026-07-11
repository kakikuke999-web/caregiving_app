class AddDailyReportFieldsToAdlRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :adl_records, :bathed, :boolean
    add_column :adl_records, :medication_taken, :boolean
    add_column :adl_records, :urination_count, :integer
    add_column :adl_records, :bowel_movement, :boolean
    add_column :adl_records, :breakfast_staple, :integer
    add_column :adl_records, :breakfast_side, :integer
    add_column :adl_records, :lunch_staple, :integer
    add_column :adl_records, :lunch_side, :integer
    add_column :adl_records, :dinner_staple, :integer
    add_column :adl_records, :dinner_side, :integer
  end
end
