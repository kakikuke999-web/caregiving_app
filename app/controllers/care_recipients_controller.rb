class CareRecipientsController < ApplicationController
  def index
    @care_recipients = CareRecipient.all
  end

  def show
    @care_recipient = CareRecipient.find(params[:id])
  end

  def new
    @care_recipient = CareRecipient.new
  end

  def create
    @care_recipient = CareRecipient.new(care_recipient_params)
    if @care_recipient.save
      redirect_to @care_recipient, notice: "登録しました"
    else
      render :new
    end
  end

  def calendar
    @care_recipient = CareRecipient.find(params[:id])
  end


  private

  def care_recipient_params
    params.require(:care_recipient).permit(:name, :dob, :emergency_contact, :allergies)
  end

end
