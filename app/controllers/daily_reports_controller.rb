class DailyReportsController < ApplicationController
  before_action :set_care_recipient
  before_action :authorize_daily_report

  def new
    @form = DailyReportForm.new(visited_on: Date.current)
  end

  def create
    @form = DailyReportForm.new(daily_report_params)
    @form.care_recipient = @care_recipient
    @form.recorded_by = current_user

    if @form.save
      redirect_to @form.visit_report, notice: "日誌を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def authorize_daily_report
    authorize :daily_report, :create?, policy_class: DailyReportPolicy
  end

  def daily_report_params
    params.require(:daily_report_form).permit(
      :visited_on, :temperature, :systolic, :diastolic, :pulse,
      :bathed, :medication_taken, :urination_count, :bowel_movement,
      :lunch_staple, :lunch_side, :notes
    )
  end
end
