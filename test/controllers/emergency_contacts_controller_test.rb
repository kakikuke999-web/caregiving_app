require "test_helper"

class EmergencyContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:one)
    @emergency_contact = emergency_contacts(:one)
  end

  test "admin can create an emergency contact" do
    sign_in users(:one)
    assert_difference("EmergencyContact.count") do
      post care_recipient_emergency_contacts_url(@care_recipient),
           params: { emergency_contact: { name: "鈴木太郎", relationship: "次男", phone_number: "090-5555-6666" } }
    end
    assert_redirected_to care_recipient_url(@care_recipient)
  end

  test "staff cannot create an emergency contact" do
    sign_in users(:staff_one)
    assert_no_difference("EmergencyContact.count") do
      post care_recipient_emergency_contacts_url(@care_recipient),
           params: { emergency_contact: { name: "鈴木太郎", relationship: "次男", phone_number: "090-5555-6666" } }
    end
    assert_redirected_to root_path
  end

  test "admin can edit and update an emergency contact" do
    sign_in users(:one)
    get edit_care_recipient_emergency_contact_url(@care_recipient, @emergency_contact)
    assert_response :success

    patch care_recipient_emergency_contact_url(@care_recipient, @emergency_contact),
          params: { emergency_contact: { phone_number: "090-9999-8888" } }
    assert_redirected_to care_recipient_url(@care_recipient)
    assert_equal "090-9999-8888", @emergency_contact.reload.phone_number
  end

  test "admin can destroy an emergency contact" do
    sign_in users(:one)
    assert_difference("EmergencyContact.count", -1) do
      delete care_recipient_emergency_contact_url(@care_recipient, @emergency_contact)
    end
    assert_redirected_to care_recipient_url(@care_recipient)
  end

  test "staff cannot destroy an emergency contact" do
    sign_in users(:staff_one)
    assert_no_difference("EmergencyContact.count") do
      delete care_recipient_emergency_contact_url(@care_recipient, @emergency_contact)
    end
  end
end
