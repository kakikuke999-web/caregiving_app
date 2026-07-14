class AddUnitCountToVisitTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :visit_types, :unit_count, :integer
  end
end
