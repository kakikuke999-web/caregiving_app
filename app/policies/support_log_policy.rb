class SupportLogPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      case user.role
      when "admin", "care_manager", "staff"
        scope.all
      else
        scope.none
      end
    end
  end

  def index?
    user.admin? || user.care_manager? || user.staff?
  end

  def show?
    index?
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
