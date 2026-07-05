require "test_helper"

class FamilyMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @care_recipient = care_recipients(:two)
    @membership = family_memberships(:one)
  end

  test "admin can link a family user to a care recipient" do
    sign_in users(:one)

    assert_difference("FamilyMembership.count") do
      post care_recipient_family_memberships_url(@care_recipient),
        params: { family_membership: { user_id: users(:family_two).id } }
    end

    assert_redirected_to care_recipient_url(@care_recipient)
  end

  test "rejects a user without the family role" do
    sign_in users(:one)

    assert_no_difference("FamilyMembership.count") do
      post care_recipient_family_memberships_url(@care_recipient),
        params: { family_membership: { user_id: users(:staff_one).id } }
    end

    assert_redirected_to care_recipient_url(@care_recipient)
  end

  test "staff cannot link family users" do
    sign_in users(:staff_one)

    assert_no_difference("FamilyMembership.count") do
      post care_recipient_family_memberships_url(@care_recipient),
        params: { family_membership: { user_id: users(:family_two).id } }
    end
  end

  test "admin can remove a family membership" do
    sign_in users(:one)

    assert_difference("FamilyMembership.count", -1) do
      delete care_recipient_family_membership_url(care_recipients(:one), @membership)
    end

    assert_redirected_to care_recipient_url(care_recipients(:one))
  end

  test "staff cannot remove a family membership" do
    sign_in users(:staff_one)

    assert_no_difference("FamilyMembership.count") do
      delete care_recipient_family_membership_url(care_recipients(:one), @membership)
    end
  end
end
