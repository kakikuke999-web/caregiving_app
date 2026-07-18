require "test_helper"

class AlertNotificationPolicyTest < ActiveSupport::TestCase
  test "admin and care_manager can send a test alert digest" do
    assert AlertNotificationPolicy.new(users(:one), :alert_notification).send_test?
    assert AlertNotificationPolicy.new(users(:care_manager_one), :alert_notification).send_test?
  end

  test "staff and family cannot" do
    assert_not AlertNotificationPolicy.new(users(:staff_one), :alert_notification).send_test?
    assert_not AlertNotificationPolicy.new(users(:family_one), :alert_notification).send_test?
  end
end
