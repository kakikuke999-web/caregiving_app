class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.admin? || user.care_manager? ? scope.all : scope.none
    end
  end

  def index?
    user.admin? || user.care_manager?
  end

  def create?
    user.admin? || user.care_manager?
  end

  def update?
    user.admin? || user.care_manager?
  end

  # care_manager can create/edit users but must not be able to grant admin
  # access to anyone (including themselves) — only an existing admin can do
  # that. The record's current role is always included so a care_manager
  # editing an existing admin's other fields doesn't silently demote them
  # (for a new, unsaved record this is simply nil, so it's dropped).
  def assignable_roles
    base = user.admin? ? User.roles.keys : User.roles.keys - ["admin"]
    (base + [record.role]).compact.uniq
  end
end
