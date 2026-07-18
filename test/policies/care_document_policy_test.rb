require "test_helper"

class CareDocumentPolicyTest < ActiveSupport::TestCase
  test "staff can create and update but not destroy" do
    policy = CareDocumentPolicy.new(users(:staff_one), care_documents(:one))
    assert policy.create?
    assert policy.update?
    assert_not policy.destroy?
  end

  test "admin and care_manager can destroy" do
    assert CareDocumentPolicy.new(users(:one), care_documents(:one)).destroy?
    assert CareDocumentPolicy.new(users(:care_manager_one), care_documents(:one)).destroy?
  end

  test "family can view own recipient's documents but not create" do
    policy = CareDocumentPolicy.new(users(:family_one), care_documents(:one))
    assert policy.show?
    assert_not policy.create?
  end

  test "family cannot view other recipient's documents" do
    assert_not CareDocumentPolicy.new(users(:family_one), care_documents(:two)).show?
  end

  test "scope resolves to accessible recipients only for family" do
    scope = CareDocumentPolicy::Scope.new(users(:family_one), CareDocument).resolve
    assert_includes scope, care_documents(:one)
    assert_not_includes scope, care_documents(:two)
  end

  test "scope resolves to all documents for staff" do
    scope = CareDocumentPolicy::Scope.new(users(:staff_one), CareDocument).resolve
    assert_includes scope, care_documents(:one)
    assert_includes scope, care_documents(:two)
  end
end
