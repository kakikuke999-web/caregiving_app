require "test_helper"

class RecurringScheduleGeneratorTest < ActiveSupport::TestCase
  setup do
    @care_recipient = care_recipients(:one)
    @schedule = RecurringSchedule.create!(
      care_recipient: @care_recipient,
      visit_type: visit_types(:one),
      user: users(:staff_one),
      created_by: users(:one),
      day_of_week: Date.current.wday,
      start_time: "10:00",
      end_time: "11:00"
    )
  end

  test "creates a planned visit report for each matching date in the window" do
    result = RecurringScheduleGenerator.call(care_recipient: @care_recipient, weeks_ahead: 2)

    assert_equal 3, result.created # today + 2 weekly occurrences
    assert_equal 0, result.skipped

    created_reports = @care_recipient.visit_reports.where(recurring_schedule: @schedule)
    assert_equal 3, created_reports.count
    assert created_reports.all? { |r| r.planned? }
    assert created_reports.all? { |r| r.user == users(:staff_one) }
  end

  test "is idempotent across repeated runs" do
    RecurringScheduleGenerator.call(care_recipient: @care_recipient, weeks_ahead: 2)

    assert_no_difference("VisitReport.count") do
      result = RecurringScheduleGenerator.call(care_recipient: @care_recipient, weeks_ahead: 2)
      assert_equal 0, result.created
      assert_equal 3, result.skipped
    end
  end

  test "skips inactive schedules" do
    @schedule.update!(active: false)

    result = RecurringScheduleGenerator.call(care_recipient: @care_recipient, weeks_ahead: 2)

    assert_equal 0, result.created
  end

  test "generated reports for an external provider have no user" do
    @schedule.update!(user: nil, provider_name: "ふれんず訪問看護ステーション")

    RecurringScheduleGenerator.call(care_recipient: @care_recipient, weeks_ahead: 0)

    report = @care_recipient.visit_reports.find_by(recurring_schedule: @schedule)
    assert_nil report.user
    assert_equal "ふれんず訪問看護ステーション", report.provider_name
  end
end
