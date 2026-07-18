class HomeController < ApplicationController
  def index
    @care_recipients = policy_scope(CareRecipient).order(:name)

    if current_user.staff?
      @today_visits = VisitReport.where(user: current_user, visited_at: Time.zone.now.all_day)
                                  .where.not(status: :missed)
                                  .includes(:care_recipient, :visit_type)
                                  .order(:visited_at)
    end

    # 家族アカウントで紐付いている対象者が1人だけなら、選択画面を省いて直接メニューへ。
    if current_user.family? && @care_recipients.one?
      redirect_to show_menu_path(care_recipient_id: @care_recipients.first.id)
    end
  end

  def show_menu
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
    authorize @care_recipient, :show?
  end
end
