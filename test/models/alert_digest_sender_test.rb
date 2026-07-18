require "test_helper"

class AlertDigestSenderTest < ActiveSupport::TestCase
  setup do
    care_recipients(:one).update!(care_level_valid_until: 1.day.ago.to_date)
  end

  test "sends a digest to a user with alerts and records the send date" do
    user = users(:one)
    user.update!(last_alert_email_sent_on: nil)

    assert_emails 1 do
      results = AlertDigestSender.call(users: [user])
      assert results.first.sent
    end

    assert_equal Date.current, user.reload.last_alert_email_sent_on
  end

  test "does not send twice on the same day unless forced" do
    user = users(:one)
    user.update!(last_alert_email_sent_on: Date.current)

    assert_emails 0 do
      result = AlertDigestSender.call(users: [user]).first
      assert_not result.sent
      assert_equal :already_sent_today, result.reason
    end

    assert_emails 1 do
      result = AlertDigestSender.call(users: [user], force: true).first
      assert result.sent
    end
  end

  test "respects the opt-out flag" do
    user = users(:one)
    user.update!(alert_emails_enabled: false, last_alert_email_sent_on: nil)

    assert_emails 0 do
      result = AlertDigestSender.call(users: [user]).first
      assert_not result.sent
      assert_equal :opted_out, result.reason
    end
  end

  test "does not send when the user has no alerts" do
    care_recipients(:one).update!(care_level_valid_until: nil)
    care_recipients(:two).update!(care_level_valid_until: nil)
    user = users(:family_two) # linked to no recipients with alerts by default
    user.update!(last_alert_email_sent_on: nil)

    assert_emails 0 do
      result = AlertDigestSender.call(users: [user]).first
      assert_not result.sent
      assert_equal :no_alerts, result.reason
    end
  end
end
