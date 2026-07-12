class DailyReportImportPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
