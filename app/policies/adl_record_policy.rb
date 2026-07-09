class AdlRecordPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      case user.role
      when "admin", "care_manager", "staff"
        scope.all
      when "family"
        scope.joins(care_recipient: :family_memberships)
             .where(family_memberships: { user_id: user.id })
      else
        scope.none
      end
    end
  end

  def index?
    true
  end

  def show?
    return true if user.admin? || user.care_manager? || user.staff?

    record.care_recipient.family_memberships.exists?(user_id: user.id)
  end

  def create?
    user.admin? || user.care_manager? || user.staff?
  end

  def update?
    create?
  end

  def destroy?
    user.admin? || user.care_manager?
  end
end
