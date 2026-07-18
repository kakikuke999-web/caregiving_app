class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # ケアマネージャー・管理者はケース一覧のダッシュボードへ、スタッフ・家族は
  # 用途に合わせて作り込んだホーム画面(home#index)へ、ログイン直後の行き先を分ける。
  def after_sign_in_path_for(resource)
    if resource.respond_to?(:admin?) && (resource.admin? || resource.care_manager?)
      dashboard_path
    else
      root_path
    end
  end

  private

  def user_not_authorized
    redirect_back fallback_location: root_path, alert: "この操作を行う権限がありません"
  end
end
