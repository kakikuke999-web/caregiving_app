require "test_helper"

class ServiceUsageSlipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
  end

  test "admin can view the service usage slip" do
    sign_in users(:one)
    get care_recipient_service_usage_slip_url(@care_recipient)
    assert_response :success
  end

  test "family cannot view the service usage slip" do
    sign_in users(:family_one)
    get care_recipient_service_usage_slip_url(@care_recipient)
    assert_redirected_to root_path
  end

  test "renders a grid row pair (予定/実績) for each visit-type/assignee group" do
    sign_in users(:one)

    month = Date.current.beginning_of_month
    VisitReport.create!(care_recipient: @care_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: month + 2.days + 10.hours, status: :completed)

    get care_recipient_service_usage_slip_url(@care_recipient, month: month.strftime("%Y-%m"))
    assert_response :success
    assert_select ".slip-grid tbody tr", count: 2
  end

  test "an unset month falls back to the current month" do
    sign_in users(:one)
    get care_recipient_service_usage_slip_url(@care_recipient)
    assert_response :success
    assert_select "strong", text: /#{Date.current.year}年#{Date.current.month}月/
  end
end
