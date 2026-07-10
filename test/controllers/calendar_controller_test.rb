require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the cross-recipient calendar" do
    sign_in users(:one)
    get calendar_url
    assert_response :success
  end

  test "care_manager can view the cross-recipient calendar" do
    sign_in users(:care_manager_one)
    get calendar_url
    assert_response :success
  end

  test "staff cannot view the cross-recipient calendar" do
    sign_in users(:staff_one)
    get calendar_url
    assert_redirected_to root_path
  end

  test "family cannot view the cross-recipient calendar" do
    sign_in users(:family_one)
    get calendar_url
    assert_redirected_to root_path
  end
end
