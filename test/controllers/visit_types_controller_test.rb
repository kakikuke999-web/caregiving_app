require "test_helper"

class VisitTypesControllerTest < ActionDispatch::IntegrationTest
  test "admin can view the visit types list" do
    sign_in users(:one)
    get visit_types_url
    assert_response :success
  end

  test "staff cannot view the visit types list" do
    sign_in users(:staff_one)
    get visit_types_url
    assert_redirected_to root_path
  end

  test "admin can create a visit type" do
    sign_in users(:one)
    assert_difference("VisitType.count") do
      post visit_types_url, params: { visit_type: { name: "リハビリ訪問" } }
    end
    assert_redirected_to visit_types_url
  end

  test "staff cannot create a visit type" do
    sign_in users(:staff_one)
    assert_no_difference("VisitType.count") do
      post visit_types_url, params: { visit_type: { name: "リハビリ訪問" } }
    end
  end

  test "admin can update a visit type" do
    sign_in users(:one)
    visit_type = visit_types(:one)
    patch visit_type_url(visit_type), params: { visit_type: { name: "更新後の名称" } }
    assert_redirected_to visit_types_url
    assert_equal "更新後の名称", visit_type.reload.name
  end

  test "admin can destroy an unused visit type" do
    sign_in users(:one)
    visit_type = VisitType.create!(name: "削除用タイプ")
    assert_difference("VisitType.count", -1) do
      delete visit_type_url(visit_type)
    end
  end
end
