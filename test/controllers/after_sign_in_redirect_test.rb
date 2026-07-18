require "test_helper"

# after_sign_in_path_for isn't exercised by the Devise::Test::IntegrationHelpers#sign_in
# shortcut (it bypasses Devise::SessionsController entirely), so this needs a real
# login POST against a user with an actual password, not a fixture.
class AfterSignInRedirectTest < ActionDispatch::IntegrationTest
  def sign_in_via_form(user, password)
    post user_session_path, params: { user: { email: user.email, password: password } }
  end

  test "admin and care_manager land on the dashboard after signing in" do
    admin = User.create!(email: "redirect_admin@example.com", password: "password123", password_confirmation: "password123",
                          name: "Redirect Admin", role: "admin")
    sign_in_via_form(admin, "password123")
    assert_redirected_to dashboard_path

    care_manager = User.create!(email: "redirect_cm@example.com", password: "password123", password_confirmation: "password123",
                                 name: "Redirect CM", role: "care_manager")
    sign_in_via_form(care_manager, "password123")
    assert_redirected_to dashboard_path
  end

  test "staff and family land on the home page after signing in" do
    staff = User.create!(email: "redirect_staff@example.com", password: "password123", password_confirmation: "password123",
                          name: "Redirect Staff", role: "staff")
    sign_in_via_form(staff, "password123")
    assert_redirected_to root_path

    family = User.create!(email: "redirect_family@example.com", password: "password123", password_confirmation: "password123",
                           name: "Redirect Family", role: "family")
    sign_in_via_form(family, "password123")
    assert_redirected_to root_path
  end
end
