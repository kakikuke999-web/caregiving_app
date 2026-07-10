require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the dashboard" do
    sign_in users(:one)
    get dashboard_url
    assert_response :success
  end

  test "care_manager can view the dashboard" do
    sign_in users(:care_manager_one)
    get dashboard_url
    assert_response :success
  end

  test "staff cannot view the dashboard" do
    sign_in users(:staff_one)
    get dashboard_url
    assert_redirected_to root_path
  end

  test "family cannot view the dashboard" do
    sign_in users(:family_one)
    get dashboard_url
    assert_redirected_to root_path
  end

  test "flags a care recipient with no recent records and counts missed visits" do
    sign_in users(:one)

    stale_recipient = CareRecipient.create!(name: "Stale Recipient", care_level: "要介護1")
    VisitReport.create!(care_recipient: stale_recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: 1.day.ago, status: :missed)

    get dashboard_url
    assert_response :success
    assert_select "a", text: "Stale Recipient"
    assert_select ".status-badge.warning", text: /要確認/
    assert_select ".status-badge.critical", text: /1件/
  end
end
