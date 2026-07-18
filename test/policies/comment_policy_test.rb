require "test_helper"

class CommentPolicyTest < ActiveSupport::TestCase
  test "create is allowed for anyone who can view the underlying visit report" do
    assert CommentPolicy.new(users(:staff_one), comments(:one)).create?
    assert CommentPolicy.new(users(:family_one), comments(:one)).create?
  end

  test "create is blocked for a family member without access to the visit report's recipient" do
    assert_not CommentPolicy.new(users(:family_one), comments(:two)).create?
  end

  test "admin and care_manager can destroy any comment" do
    assert CommentPolicy.new(users(:one), comments(:two)).destroy?
    assert CommentPolicy.new(users(:care_manager_one), comments(:two)).destroy?
  end

  test "the comment's author can destroy their own comment even without admin/care_manager rights" do
    comment = Comment.new(visit_report: visit_reports(:one), user: users(:staff_one))
    assert CommentPolicy.new(users(:staff_one), comment).destroy?
  end

  test "a non-author, non-admin/care_manager user cannot destroy someone else's comment" do
    comment = Comment.new(visit_report: visit_reports(:one), user: users(:staff_one))
    assert_not CommentPolicy.new(users(:family_one), comment).destroy?
  end
end
