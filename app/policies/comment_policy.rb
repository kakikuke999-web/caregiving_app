class CommentPolicy < ApplicationPolicy
  # コメントは紐づく訪問記録を閲覧できるユーザーなら誰でも投稿できる（家族も含む）
  def create?
    VisitReportPolicy.new(user, record.visit_report).show?
  end

  # 削除は管理者・ケアマネージャー、または投稿者本人のみ
  def destroy?
    user.admin? || user.care_manager? || record.user_id == user.id
  end
end
