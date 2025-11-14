require "test_helper"

class VisitReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get visit_reports_index_url
    assert_response :success
  end

  test "should get show" do
    get visit_reports_show_url
    assert_response :success
  end

  test "should get new" do
    get visit_reports_new_url
    assert_response :success
  end

  test "should get edit" do
    get visit_reports_edit_url
    assert_response :success
  end
end
