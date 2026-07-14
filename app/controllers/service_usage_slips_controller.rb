class ServiceUsageSlipsController < ApplicationController
  before_action :set_care_recipient

  def show
    authorize @care_recipient, :show?, policy_class: ServiceUsageSlipPolicy

    @month = parse_month(params[:month]) || Date.current.beginning_of_month
    @rows = ServiceUsageSlip.new(care_recipient: @care_recipient, month: @month).rows
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def parse_month(value)
    return nil if value.blank?

    Date.parse("#{value}-01")
  rescue ArgumentError, TypeError
    nil
  end
end
