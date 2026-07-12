class AddRecurringScheduleToVisitReports < ActiveRecord::Migration[7.1]
  def change
    add_reference :visit_reports, :recurring_schedule, null: true, foreign_key: true
  end
end
