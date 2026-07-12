require "test_helper"

class DailyReportBulkImportTest < ActiveSupport::TestCase
  setup do
    @care_recipient = care_recipients(:one)
    @json = [
      {
        date: "2026-01-05", temperature: 36.4, blood_pressures: [[120, 70]], pulses: [80],
        lunch_staple: 10, lunch_side: 10, bathed: true, medication_taken: true,
        urination_count: 2, bowel_movement: false, recorder_email: users(:staff_one).email,
        notes: "テスト記録"
      }
    ].to_json
  end

  test "creates a visit report, vitals, and an adl record from JSON" do
    result = DailyReportBulkImport.call(care_recipient: @care_recipient, json: @json)

    assert_equal 1, result.created
    assert_equal 0, result.skipped
    assert_empty result.errors

    visit_report = @care_recipient.visit_reports.find_by(visited_at: Time.zone.parse("2026-01-05 10:00"))
    assert_not_nil visit_report
    assert_equal users(:staff_one), visit_report.user
    assert_equal "completed", visit_report.status
  end

  test "skips a date that already has a visit report" do
    DailyReportBulkImport.call(care_recipient: @care_recipient, json: @json)
    result = DailyReportBulkImport.call(care_recipient: @care_recipient, json: @json)

    assert_equal 0, result.created
    assert_equal 1, result.skipped
  end

  test "falls back to an admin user when recorder_email is blank" do
    json = [{ date: "2026-01-06", notes: "記入者なし" }].to_json
    result = DailyReportBulkImport.call(care_recipient: @care_recipient, json: json)

    assert_equal 1, result.created
    visit_report = @care_recipient.visit_reports.find_by(visited_at: Time.zone.parse("2026-01-06 10:00"))
    assert visit_report.user.admin?
  end
end
