require "test_helper"

class DailyReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
  end

  test "staff can register a daily report for any visit type and it creates a visit report, vitals, and an adl record" do
    sign_in users(:staff_one)

    assert_difference(["VisitReport.count", "AdlRecord.count"], 1) do
      assert_difference("Vital.count", 3) do
        post care_recipient_daily_reports_url(@care_recipient), params: {
          daily_report_form: {
            visit_type_id: visit_types(:day_service).id,
            visited_at: "2025-12-26T14:30",
            temperature: "36.0",
            systolic: "127",
            diastolic: "75",
            pulse: "86",
            lunch_staple: "10",
            lunch_side: "10",
            bathed: "true",
            medication_taken: "true",
            urination_count: "2",
            bowel_movement: "false",
            notes: "元気に来所されました。"
          }
        }
      end
    end

    visit_report = VisitReport.last
    assert_equal @care_recipient, visit_report.care_recipient
    assert_equal users(:staff_one), visit_report.user
    assert_equal visit_types(:day_service), visit_report.visit_type
    assert_equal "completed", visit_report.status
    assert_equal Time.zone.local(2025, 12, 26, 14, 30), visit_report.visited_at
    assert_redirected_to visit_report_url(visit_report)

    adl_record = AdlRecord.last
    assert_equal true, adl_record.bathed
    assert_equal false, adl_record.bowel_movement
    assert_equal 2, adl_record.urination_count

    recorded_types = @care_recipient.vitals.where(recorded_at: visit_report.visited_at).order(:type).pluck(:type)
    assert_equal %w[blood_pressure pulse temperature], recorded_types
  end

  test "family cannot register a daily report" do
    sign_in users(:family_one)

    assert_no_difference("VisitReport.count") do
      post care_recipient_daily_reports_url(@care_recipient), params: {
        daily_report_form: { visit_type_id: visit_types(:day_service).id, visited_at: "2025-12-26T10:00", notes: "不正な登録" }
      }
    end
  end

  test "rejects a blood pressure with only one of systolic/diastolic filled in" do
    sign_in users(:staff_one)

    assert_no_difference("VisitReport.count") do
      post care_recipient_daily_reports_url(@care_recipient), params: {
        daily_report_form: { visit_type_id: visit_types(:day_service).id, visited_at: "2025-12-26T10:00", systolic: "127" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "rejects a report with no visit type selected" do
    sign_in users(:staff_one)

    assert_no_difference("VisitReport.count") do
      post care_recipient_daily_reports_url(@care_recipient), params: {
        daily_report_form: { visited_at: "2025-12-26T10:00" }
      }
    end
    assert_response :unprocessable_entity
  end
end
