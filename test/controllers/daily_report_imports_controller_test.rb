require "test_helper"

class DailyReportImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @json = [
      { date: "2026-01-05", temperature: 36.4, blood_pressures: [[120, 70]], pulses: [80], notes: "テスト" }
    ].to_json
  end

  test "admin can bulk import" do
    sign_in users(:one)

    assert_difference("VisitReport.count") do
      post care_recipient_daily_report_imports_url(@care_recipient), params: { json: @json }
    end
    assert_response :success
  end

  test "staff cannot access the bulk import" do
    sign_in users(:staff_one)

    assert_no_difference("VisitReport.count") do
      post care_recipient_daily_report_imports_url(@care_recipient), params: { json: @json }
    end
  end
end
