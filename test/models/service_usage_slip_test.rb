require "test_helper"

class ServiceUsageSlipTest < ActiveSupport::TestCase
  test "groups visits by visit type and assignee, separating scheduled from completed days" do
    care_recipient = care_recipients(:one)
    month = Date.current.beginning_of_month

    VisitReport.create!(care_recipient: care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: month + 2.days + 10.hours, status: :completed)
    VisitReport.create!(care_recipient: care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: month + 9.days + 10.hours, status: :planned)

    rows = ServiceUsageSlip.new(care_recipient: care_recipient, month: month).rows

    row = rows.find { |r| r.visit_type_name == visit_types(:one).name && r.assignee == users(:staff_one).name }
    assert row, "expected a row for the staff_one / visit_types(:one) group"
    assert_equal [(month + 2.days).day, (month + 9.days).day], row.scheduled_days
    assert_equal [(month + 2.days).day], row.completed_days
  end

  test "separates rows for the same visit type provided by different assignees" do
    care_recipient = care_recipients(:one)
    month = Date.current.beginning_of_month

    VisitReport.create!(care_recipient: care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: month + 1.day + 9.hours, status: :completed)
    VisitReport.create!(care_recipient: care_recipient, provider_name: "外部訪問看護ステーション", visit_type: visit_types(:one),
                         visited_at: month + 1.day + 9.hours, status: :completed)

    rows = ServiceUsageSlip.new(care_recipient: care_recipient, month: month).rows
    assignees = rows.map(&:assignee)

    assert_includes assignees, users(:staff_one).name
    assert_includes assignees, "外部訪問看護ステーション"
  end

  test "returns no rows for a month with no visits" do
    care_recipient = care_recipients(:one)
    rows = ServiceUsageSlip.new(care_recipient: care_recipient, month: 50.years.ago.beginning_of_month.to_date).rows
    assert_equal [], rows
  end
end
