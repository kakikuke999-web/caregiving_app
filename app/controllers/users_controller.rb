class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    @users = policy_scope(User)
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if user_params[:role].present? && !policy(@user).assignable_roles.include?(user_params[:role])
      return redirect_to edit_user_path(@user), alert: "管理者権限への変更は管理者のみが行えます"
    end

    if @user.update(user_params)
      redirect_to users_path, notice: "ユーザー情報を更新しました"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :alert_emails_enabled)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
