class PersonalSchedulePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      case user.role
      when "admin", "care_manager", "staff"
        scope.all
      when "family"
        scope.joins(care_recipient: :family_memberships).where(family_memberships: { user_id: user.id })
      else
        scope.none
      end
    end
  end

  def index?
    true
  end

  # 家族は自分が紐付く対象者の予定のみ閲覧・登録・編集・削除できる
  def show?
    return true if user.admin? || user.care_manager? || user.staff?

    record.care_recipient.family_memberships.exists?(user_id: user.id)
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
