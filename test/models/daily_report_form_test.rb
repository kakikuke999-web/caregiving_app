require "test_helper"

class DailyReportFormTest < ActiveSupport::TestCase
  setup do
    @form = DailyReportForm.new(
      care_recipient: care_recipients(:one),
      recorded_by: users(:staff_one),
      visit_type_id: visit_types(:day_service).id,
      visited_at: Time.zone.local(2025, 12, 26, 14, 30)
    )
  end

  test "requires visited_at" do
    @form.visited_at = nil
    assert_not @form.valid?
  end

  test "requires a visit type" do
    @form.visit_type_id = nil
    assert_not @form.valid?
  end

  test "rejects a lone systolic or diastolic value" do
    @form.systolic = 127
    assert_not @form.valid?
    assert_includes @form.errors[:base], "血圧は上下ともに入力してください"
  end

  test "saving creates a completed visit report with the exact date and time given, tagged with the chosen visit type" do
    assert @form.save
    assert_equal "completed", @form.visit_report.status
    assert_equal visit_types(:day_service), @form.visit_report.visit_type
    assert_equal Time.zone.local(2025, 12, 26, 14, 30), @form.visit_report.visited_at
  end
end
