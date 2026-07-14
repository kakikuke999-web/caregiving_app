class AddIsMonitoringToVisitReports < ActiveRecord::Migration[7.1]
  def change
    add_column :visit_reports, :is_monitoring, :boolean, default: false, null: false
  end
end
