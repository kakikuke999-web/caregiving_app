class FamilyMembershipsController < ApplicationController
  before_action :set_care_recipient

  def create
    authorize @care_recipient, :update?

    membership = @care_recipient.family_memberships.build(family_membership_params)
    if membership.save
      redirect_to @care_recipient, notice: "家族アカウントを紐付けました"
    else
      redirect_to @care_recipient, alert: membership.errors.full_messages.to_sentence
    end
  end

  def destroy
    authorize @care_recipient, :update?

    @care_recipient.family_memberships.find(params[:id]).destroy
    redirect_to @care_recipient, notice: "家族アカウントの紐付けを解除しました"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def family_membership_params
    params.require(:family_membership).permit(:user_id)
  end
end
