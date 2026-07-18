require "test_helper"

class VisitReportPolicyTest < ActiveSupport::TestCase
  test "index is open to everyone (actual visibility is enforced by the scope)" do
    assert VisitReportPolicy.new(users(:family_one), VisitReport).index?
  end

  test "admin, care_manager, and staff can view, create, and update any visit report" do
    [:one, :care_manager_one, :staff_one].each do |fixture|
      policy = VisitReportPolicy.new(users(fixture), visit_reports(:two))
      assert policy.show?
      assert policy.create?
      assert policy.update?
    end
  end

  test "family can view their own recipient's visit report but not create or update" do
    policy = VisitReportPolicy.new(users(:family_one), visit_reports(:one))
    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
  end

  test "family cannot view another recipient's visit report" do
    assert_not VisitReportPolicy.new(users(:family_one), visit_reports(:two)).show?
  end

  test "only admin and care_manager can destroy" do
    assert VisitReportPolicy.new(users(:one), visit_reports(:one)).destroy?
    assert VisitReportPolicy.new(users(:care_manager_one), visit_reports(:one)).destroy?
    assert_not VisitReportPolicy.new(users(:staff_one), visit_reports(:one)).destroy?
    assert_not VisitReportPolicy.new(users(:family_one), visit_reports(:one)).destroy?
  end

  test "scope resolves to all visit reports for staff, only own recipient's for family" do
    assert_includes VisitReportPolicy::Scope.new(users(:staff_one), VisitReport).resolve, visit_reports(:two)

    family_scope = VisitReportPolicy::Scope.new(users(:family_one), VisitReport).resolve
    assert_includes family_scope, visit_reports(:one)
    assert_not_includes family_scope, visit_reports(:two)
  end
end
