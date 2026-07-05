class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.admin? || user.care_manager? ? scope.all : scope.none
    end
  end

  def index?
    user.admin? || user.care_manager?
  end

  def update?
    user.admin? || user.care_manager?
  end
end
