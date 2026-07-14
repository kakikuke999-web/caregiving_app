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

  test "flags a care recipient with an expired or soon-expiring certification" do
    sign_in users(:one)

    CareRecipient.create!(name: "Expired Cert", care_level: "要介護1", care_level_valid_until: 1.day.ago.to_date)

    get dashboard_url
    assert_response :success
    assert_select ".status-badge.critical", text: /期限切れ/
  end

  test "counts recipients without a monitoring visit this month" do
    sign_in users(:one)

    recipient = CareRecipient.create!(name: "No Monitoring", care_level: "要介護1")

    get dashboard_url
    assert_response :success
    assert_select "a", text: "No Monitoring"
    assert_select ".status-badge.warning", text: /未実施/

    VisitReport.create!(care_recipient: recipient, user: users(:staff_one), visit_type: visit_types(:one),
                         visited_at: Time.current, status: :completed, is_monitoring: true)

    get dashboard_url
    assert_select ".status-badge.good", text: /実施済み/
  end

  test "mine only filter scopes to the current user's assigned recipients" do
    sign_in users(:care_manager_one)

    CareRecipient.create!(name: "Someone Else's Case", care_level: "要介護1")
    CareRecipient.create!(name: "My Case", care_level: "要介護1", primary_care_manager: users(:care_manager_one))

    get dashboard_url(mine: 1)
    assert_response :success
    assert_select "a", text: "My Case"
    assert_select "a", { text: "Someone Else's Case", count: 0 }
  end
end
