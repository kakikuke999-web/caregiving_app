require "test_helper"

class SupportLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @support_log = support_logs(:one)
  end

  test "staff can view index" do
    sign_in users(:staff_one)
    get care_recipient_support_logs_url(@care_recipient)
    assert_response :success
  end

  test "staff can create a support log" do
    sign_in users(:staff_one)
    assert_difference("SupportLog.count") do
      post care_recipient_support_logs_url(@care_recipient),
           params: { support_log: { category: "phone", occurred_at: Time.current, body: "電話で状況確認" } }
    end
    assert_redirected_to care_recipient_support_logs_url(@care_recipient)
  end

  test "family cannot view or create support logs" do
    sign_in users(:family_one)

    get care_recipient_support_logs_url(@care_recipient)
    assert_redirected_to root_path

    assert_no_difference("SupportLog.count") do
      post care_recipient_support_logs_url(@care_recipient),
           params: { support_log: { category: "phone", occurred_at: Time.current, body: "電話で状況確認" } }
    end
    assert_redirected_to root_path
  end

  test "staff cannot destroy a support log but care_manager can" do
    sign_in users(:staff_one)
    assert_no_difference("SupportLog.count") do
      delete care_recipient_support_log_url(@care_recipient, @support_log)
    end
    assert_redirected_to root_path

    sign_in users(:care_manager_one)
    assert_difference("SupportLog.count", -1) do
      delete care_recipient_support_log_url(@care_recipient, @support_log)
    end
  end
end
