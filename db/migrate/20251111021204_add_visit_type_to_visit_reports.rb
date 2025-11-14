class AddVisitTypeToVisitReports < ActiveRecord::Migration[7.1]
  def change
    add_reference :visit_reports, :visit_type, null: true, foreign_key: true
  end
end
