class EmergencyContactsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_emergency_contact, only: %i[edit update destroy]

  def new
    @emergency_contact = @care_recipient.emergency_contacts.new
    authorize @emergency_contact
  end

  def create
    @emergency_contact = @care_recipient.emergency_contacts.new(emergency_contact_params)
    authorize @emergency_contact

    if @emergency_contact.save
      redirect_to @care_recipient, notice: "緊急連絡先を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @emergency_contact
  end

  def update
    authorize @emergency_contact

    if @emergency_contact.update(emergency_contact_params)
      redirect_to @care_recipient, notice: "緊急連絡先を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @emergency_contact
    @emergency_contact.destroy!
    redirect_to @care_recipient, notice: "緊急連絡先を削除しました", status: :see_other
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_emergency_contact
    @emergency_contact = @care_recipient.emergency_contacts.find(params[:id])
  end

  def emergency_contact_params
    params.require(:emergency_contact).permit(:name, :relationship, :phone_number, :priority, :note)
  end
end
