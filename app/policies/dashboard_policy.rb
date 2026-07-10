class DashboardPolicy < ApplicationPolicy
  def index?
    user.admin? || user.care_manager?
  end
end
