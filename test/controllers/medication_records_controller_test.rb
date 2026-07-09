require "test_helper"

class MedicationRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @medication_record = medication_records(:one)
  end

  test "staff can view index" do
    sign_in users(:staff_one)
    get care_recipient_medication_records_url(@care_recipient)
    assert_response :success
  end

  test "staff can create a medication record" do
    sign_in users(:staff_one)
    assert_difference("MedicationRecord.count") do
      post care_recipient_medication_records_url(@care_recipient),
           params: { medication_record: { medication_name: "整腸剤", taken: true, recorded_at: Time.current } }
    end
    assert_redirected_to care_recipient_medication_records_url(@care_recipient)
  end

  test "family can view but not create a medication record" do
    sign_in users(:family_one)
    get care_recipient_medication_records_url(@care_recipient)
    assert_response :success

    assert_no_difference("MedicationRecord.count") do
      post care_recipient_medication_records_url(@care_recipient),
           params: { medication_record: { medication_name: "整腸剤", taken: true, recorded_at: Time.current } }
    end
    assert_redirected_to root_path
  end

  test "should get edit" do
    sign_in users(:staff_one)
    get edit_care_recipient_medication_record_url(@care_recipient, @medication_record)
    assert_response :success
  end
end
