class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update] 
  before_action :authorize_user_edit, only: [:edit, :update]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "ユーザー情報を更新しました"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

  def set_user
    @user = User.find(params[:id])  # ✅ これがないと @user は nil
  end

  def authorize_user_edit
    return if Rails.env.development? # ✅ テスト中（開発環境）なら誰でもOK

    unless current_user.admin? || current_user.care_manager?
      redirect_to root_path, alert: "この操作は許可されていません"
    end
  end

end
