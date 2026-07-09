require "test_helper"

class VitalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @vital = vitals(:one)
  end

  test "staff can view index" do
    sign_in users(:staff_one)
    get care_recipient_vitals_url(@care_recipient)
    assert_response :success
  end

  test "staff can create a vital" do
    sign_in users(:staff_one)
    assert_difference("Vital.count") do
      post care_recipient_vitals_url(@care_recipient),
           params: { vital: { type: "pulse", value: 75, recorded_at: Time.current } }
    end
    assert_redirected_to care_recipient_vitals_url(@care_recipient)
  end

  test "family can view but not create a vital" do
    sign_in users(:family_one)
    get care_recipient_vitals_url(@care_recipient)
    assert_response :success

    assert_no_difference("Vital.count") do
      post care_recipient_vitals_url(@care_recipient),
           params: { vital: { type: "pulse", value: 75, recorded_at: Time.current } }
    end
    assert_redirected_to root_path
  end

  test "should get edit" do
    sign_in users(:staff_one)
    get edit_care_recipient_vital_url(@care_recipient, @vital)
    assert_response :success
  end
end
