class RecurringSchedulesController < ApplicationController
  before_action :set_care_recipient
  before_action :set_recurring_schedule, only: %i[edit update destroy]

  def index
    authorize @care_recipient, :show?
    @recurring_schedules = policy_scope(RecurringSchedule)
      .where(care_recipient_id: @care_recipient.id)
      .order(:day_of_week, :start_time)
  end

  def new
    @recurring_schedule = @care_recipient.recurring_schedules.new(day_of_week: 1)
    authorize @recurring_schedule
  end

  def create
    @recurring_schedule = @care_recipient.recurring_schedules.new(recurring_schedule_params)
    @recurring_schedule.created_by = current_user
    authorize @recurring_schedule

    if @recurring_schedule.save
      redirect_to care_recipient_recurring_schedules_path(@care_recipient), notice: "定期予定を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @recurring_schedule
  end

  def update
    authorize @recurring_schedule

    if @recurring_schedule.update(recurring_schedule_params)
      redirect_to care_recipient_recurring_schedules_path(@care_recipient), notice: "定期予定を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @recurring_schedule
    @recurring_schedule.destroy!
    redirect_to care_recipient_recurring_schedules_path(@care_recipient), notice: "定期予定を削除しました", status: :see_other
  end

  def generate
    authorize RecurringSchedule.new(care_recipient: @care_recipient), :generate?
    result = RecurringScheduleGenerator.call(care_recipient: @care_recipient)
    redirect_to care_recipient_recurring_schedules_path(@care_recipient),
      notice: "#{result.created}件の訪問予定を作成しました（#{result.skipped}件は既存のためスキップ）"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_recurring_schedule
    @recurring_schedule = @care_recipient.recurring_schedules.find(params[:id])
  end

  def recurring_schedule_params
    params.require(:recurring_schedule).permit(:visit_type_id, :user_id, :day_of_week, :start_time, :end_time, :provider_name, :active)
  end
end
