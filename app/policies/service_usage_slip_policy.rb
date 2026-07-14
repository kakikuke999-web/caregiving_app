class ServiceUsageSlipPolicy < ApplicationPolicy
  def show?
    user.admin? || user.care_manager? || user.staff?
  end
end
