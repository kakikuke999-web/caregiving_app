class VisitTypePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin? || user.care_manager?
  end

  def create?
    user.admin? || user.care_manager?
  end

  def update?
    create?
  end

  def destroy?
    user.admin? || user.care_manager?
  end
end
