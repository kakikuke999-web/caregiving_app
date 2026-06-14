require "application_system_test_case"

class CareRecipientsTest < ApplicationSystemTestCase
  setup do
    @care_recipient = care_recipients(:one)
  end

  test "visiting the index" do
    visit care_recipients_url
    assert_selector "h1", text: "Care recipients"
  end

  test "should create care recipient" do
    visit care_recipients_url
    click_on "New care recipient"

    fill_in "Address", with: @care_recipient.address
    fill_in "Birthday", with: @care_recipient.birthday
    fill_in "Care level", with: @care_recipient.care_level
    fill_in "Memo", with: @care_recipient.memo
    fill_in "Name", with: @care_recipient.name
    click_on "Create Care recipient"

    assert_text "Care recipient was successfully created"
    click_on "Back"
  end

  test "should update Care recipient" do
    visit care_recipient_url(@care_recipient)
    click_on "Edit this care recipient", match: :first

    fill_in "Address", with: @care_recipient.address
    fill_in "Birthday", with: @care_recipient.birthday
    fill_in "Care level", with: @care_recipient.care_level
    fill_in "Memo", with: @care_recipient.memo
    fill_in "Name", with: @care_recipient.name
    click_on "Update Care recipient"

    assert_text "Care recipient was successfully updated"
    click_on "Back"
  end

  test "should destroy Care recipient" do
    visit care_recipient_url(@care_recipient)
    click_on "Destroy this care recipient", match: :first

    assert_text "Care recipient was successfully destroyed"
  end
end
