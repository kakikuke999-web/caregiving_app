require "test_helper"

class AdlRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @adl_record = adl_records(:one)
  end

  test "staff can view index" do
    sign_in users(:staff_one)
    get care_recipient_adl_records_url(@care_recipient)
    assert_response :success
  end

  test "staff can create an adl record" do
    sign_in users(:staff_one)
    assert_difference("AdlRecord.count") do
      post care_recipient_adl_records_url(@care_recipient),
           params: { adl_record: { recorded_at: Time.current, meal_intake: "full", excretion_status: "normal", sleep_quality: "good" } }
    end
    assert_redirected_to care_recipient_adl_records_url(@care_recipient)
  end

  test "family can view but not create an adl record" do
    sign_in users(:family_one)
    get care_recipient_adl_records_url(@care_recipient)
    assert_response :success

    assert_no_difference("AdlRecord.count") do
      post care_recipient_adl_records_url(@care_recipient),
           params: { adl_record: { recorded_at: Time.current, meal_intake: "full", excretion_status: "normal", sleep_quality: "good" } }
    end
    assert_redirected_to root_path
  end

  test "should get edit" do
    sign_in users(:staff_one)
    get edit_care_recipient_adl_record_url(@care_recipient, @adl_record)
    assert_response :success
  end
end
