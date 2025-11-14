class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # current_user は Devise が提供するログインユーザー
  end
  
  def show_menu
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

end
