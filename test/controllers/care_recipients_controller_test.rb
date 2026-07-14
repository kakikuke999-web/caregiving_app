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

  test "can set the primary care manager and certification valid-until date" do
    patch care_recipient_url(@care_recipient), params: {
      care_recipient: {
        name: @care_recipient.name,
        primary_care_manager_id: users(:care_manager_one).id,
        care_level_valid_until: 6.months.from_now.to_date
      }
    }
    assert_redirected_to care_recipient_url(@care_recipient)

    @care_recipient.reload
    assert_equal users(:care_manager_one), @care_recipient.primary_care_manager
    assert_equal 6.months.from_now.to_date, @care_recipient.care_level_valid_until
  end

  test "can set service-usage-slip header fields" do
    patch care_recipient_url(@care_recipient), params: {
      care_recipient: {
        name: @care_recipient.name,
        name_kana: "タナカ カズコ",
        gender: "female",
        insurer_number: "0749-21",
        insured_person_number: "2666",
        benefit_limit_units: 16765
      }
    }
    assert_redirected_to care_recipient_url(@care_recipient)

    @care_recipient.reload
    assert_equal "タナカ カズコ", @care_recipient.name_kana
    assert_equal "女性", @care_recipient.gender_label
    assert_equal "0749-21", @care_recipient.insurer_number
    assert_equal "2666", @care_recipient.insured_person_number
    assert_equal 16765, @care_recipient.benefit_limit_units
  end

  test "should destroy care_recipient" do
    assert_difference("CareRecipient.count", -1) do
      delete care_recipient_url(@care_recipient)
    end

    assert_redirected_to care_recipients_url
  end
end
