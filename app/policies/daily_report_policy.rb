class DailyReportPolicy < ApplicationPolicy
  def create?
    user.admin? || user.care_manager? || user.staff?
  end
end
