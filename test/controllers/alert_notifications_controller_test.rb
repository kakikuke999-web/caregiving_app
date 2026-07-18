require "test_helper"

class AlertNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    care_recipients(:one).update!(care_level_valid_until: 1.day.ago.to_date)
    # このfixtureセットにはadmin/care_managerロールのユーザーが3人いる（全員が全対象者を見られる
    # ため、いずれも上記のアラート対象になる）。この1件のシークレット検証テストでは対象を1人に
    # 絞りたいので、他の2人はすでに本日送信済み扱いにしておく。
    (User.where(role: %i[admin care_manager]) - [users(:one)]).each do |user|
      user.update!(last_alert_email_sent_on: Date.current)
    end
  end

  test "trigger requires the correct shared secret" do
    original = ENV["ALERT_NOTIFICATION_SECRET"]
    ENV["ALERT_NOTIFICATION_SECRET"] = "test-secret-123"

    post alert_notifications_trigger_url, params: { token: "wrong" }
    assert_response :unauthorized

    assert_emails 1 do
      post alert_notifications_trigger_url, params: { token: "test-secret-123" }
    end
    assert_response :success
  ensure
    ENV["ALERT_NOTIFICATION_SECRET"] = original
  end

  test "trigger is rejected when no secret is configured" do
    original = ENV["ALERT_NOTIFICATION_SECRET"]
    ENV.delete("ALERT_NOTIFICATION_SECRET")

    post alert_notifications_trigger_url, params: { token: "" }
    assert_response :unauthorized
  ensure
    ENV["ALERT_NOTIFICATION_SECRET"] = original
  end

  test "care_manager can send themselves a test digest" do
    sign_in users(:one)

    assert_emails 1 do
      post alert_notifications_send_test_url
    end
    assert_redirected_to dashboard_path
  end

  test "staff cannot trigger a test digest" do
    sign_in users(:staff_one)

    assert_emails 0 do
      post alert_notifications_send_test_url
    end
    assert_redirected_to root_path
  end
end
