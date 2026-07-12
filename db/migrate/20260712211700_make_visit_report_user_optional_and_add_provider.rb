class MakeVisitReportUserOptionalAndAddProvider < ActiveRecord::Migration[7.1]
  def change
    change_column_null :visit_reports, :user_id, true
    add_column :visit_reports, :provider_name, :string
  end
end
