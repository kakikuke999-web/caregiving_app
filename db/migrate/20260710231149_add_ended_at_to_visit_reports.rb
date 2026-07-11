class AddEndedAtToVisitReports < ActiveRecord::Migration[7.1]
  def change
    add_column :visit_reports, :ended_at, :datetime
  end
end
