require "test_helper"

class VisitReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visit_report = visit_reports(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get visit_reports_url
    assert_response :success
  end

  test "should get show" do
    get visit_report_url(@visit_report)
    assert_response :success
  end

  test "should get new" do
    get new_visit_report_url, params: { care_recipient_id: @visit_report.care_recipient_id }
    assert_response :success
  end

  test "should get edit" do
    get edit_visit_report_url(@visit_report)
    assert_response :success
  end
end
