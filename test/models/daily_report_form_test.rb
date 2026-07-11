require "test_helper"

class DailyReportFormTest < ActiveSupport::TestCase
  setup do
    @form = DailyReportForm.new(
      care_recipient: care_recipients(:one),
      recorded_by: users(:staff_one),
      visited_on: Date.new(2025, 12, 26)
    )
  end

  test "requires visited_on" do
    @form.visited_on = nil
    assert_not @form.valid?
  end

  test "rejects a lone systolic or diastolic value" do
    @form.systolic = 127
    assert_not @form.valid?
    assert_includes @form.errors[:base], "血圧は上下ともに入力してください"
  end

  test "saving creates a completed visit report tagged as デイサービス" do
    assert @form.save
    assert_equal "completed", @form.visit_report.status
    assert_equal "デイサービス", @form.visit_report.visit_type.name
  end
end
