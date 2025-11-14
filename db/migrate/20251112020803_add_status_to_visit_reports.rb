class AddStatusToVisitReports < ActiveRecord::Migration[7.1]
  def change
    add_column :visit_reports, :status, :integer, default: 0, null: false
  end
end
