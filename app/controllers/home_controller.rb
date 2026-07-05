class HomeController < ApplicationController
  def index
    # current_user は Devise が提供するログインユーザー
  end

  def show_menu
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
    authorize @care_recipient, :show?
  end

end
