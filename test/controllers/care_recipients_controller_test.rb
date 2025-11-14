require "test_helper"

class CareRecipientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get care_recipients_index_url
    assert_response :success
  end

  test "should get show" do
    get care_recipients_show_url
    assert_response :success
  end

  test "should get new" do
    get care_recipients_new_url
    assert_response :success
  end

  test "should get edit" do
    get care_recipients_edit_url
    assert_response :success
  end
end
