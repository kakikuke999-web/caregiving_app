require "test_helper"

class CareRecipientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get care_recipients_url
    assert_response :success
  end

  test "should get new" do
    get new_care_recipient_url
    assert_response :success
  end

  test "should create care_recipient" do
    assert_difference("CareRecipient.count") do
      post care_recipients_url, params: { care_recipient: { address: @care_recipient.address, birthday: @care_recipient.birthday, care_level: @care_recipient.care_level, memo: @care_recipient.memo, name: @care_recipient.name } }
    end

    assert_redirected_to care_recipient_url(CareRecipient.last)
  end

  test "should show care_recipient" do
    get care_recipient_url(@care_recipient)
    assert_response :success
  end

  test "should get edit" do
    get edit_care_recipient_url(@care_recipient)
    assert_response :success
  end

  test "should update care_recipient" do
    patch care_recipient_url(@care_recipient), params: { care_recipient: { address: @care_recipient.address, birthday: @care_recipient.birthday, care_level: @care_recipient.care_level, memo: @care_recipient.memo, name: @care_recipient.name } }
    assert_redirected_to care_recipient_url(@care_recipient)
  end

  test "should update the care_recipient's linked visit types" do
    patch care_recipient_url(@care_recipient), params: {
      care_recipient: {
        name: @care_recipient.name, visit_type_ids: [visit_types(:one).id, visit_types(:two).id]
      }
    }
    assert_redirected_to care_recipient_url(@care_recipient)
    assert_equal [visit_types(:one), visit_types(:two)].sort_by(&:id), @care_recipient.reload.visit_types.sort_by(&:id)
  end

  test "should destroy care_recipient" do
    assert_difference("CareRecipient.count", -1) do
      delete care_recipient_url(@care_recipient)
    end

    assert_redirected_to care_recipients_url
  end
end
