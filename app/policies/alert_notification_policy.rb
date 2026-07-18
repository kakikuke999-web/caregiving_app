class AlertNotificationPolicy < ApplicationPolicy
  def send_test?
    user.admin? || user.care_manager?
  end
end
