require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update" do
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to users_url
  end

  test "admin can promote a user to admin" do
    target = users(:staff_one)
    patch user_url(target), params: { user: { role: "admin" } }
    assert_redirected_to users_url
    assert_equal "admin", target.reload.role
  end

  test "care_manager cannot promote a user to admin" do
    sign_out @user
    sign_in users(:care_manager_one)
    target = users(:staff_one)

    patch user_url(target), params: { user: { role: "admin" } }

    assert_redirected_to edit_user_url(target)
    assert_not_equal "admin", target.reload.role
  end
end
