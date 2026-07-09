class EnhanceVitals < ActiveRecord::Migration[7.1]
  def change
    change_column :vitals, :value, :decimal, precision: 6, scale: 2, using: "value::decimal(6,2)"
    add_column :vitals, :systolic, :integer
    add_column :vitals, :diastolic, :integer
    add_column :vitals, :note, :text
  end
end
