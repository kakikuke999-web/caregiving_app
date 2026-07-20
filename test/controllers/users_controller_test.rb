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

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "admin can create a user with any role, including admin" do
    assert_difference("User.count", 1) do
      post create_user_url, params: {
        user: { name: "新規スタッフ", email: "new_staff@example.com", role: "admin", password: "password123", password_confirmation: "password123" }
      }
    end
    assert_redirected_to users_url
    assert_equal "admin", User.last.role
  end

  test "care_manager can create a user but not with the admin role" do
    sign_out @user
    sign_in users(:care_manager_one)

    assert_no_difference("User.count") do
      post create_user_url, params: {
        user: { name: "新規スタッフ", email: "new_staff2@example.com", role: "admin", password: "password123", password_confirmation: "password123" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "care_manager can create a non-admin user" do
    sign_out @user
    sign_in users(:care_manager_one)

    assert_difference("User.count", 1) do
      post create_user_url, params: {
        user: { name: "新規家族", email: "new_family@example.com", role: "family", password: "password123", password_confirmation: "password123" }
      }
    end
    assert_equal "family", User.last.role
  end

  test "rejects creating a user with no role selected" do
    assert_no_difference("User.count") do
      post create_user_url, params: {
        user: { name: "役割なし", email: "no_role@example.com", password: "password123", password_confirmation: "password123" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "staff cannot access the new user form" do
    sign_out @user
    sign_in users(:staff_one)

    get new_user_url
    assert_response :redirect
  end
end
