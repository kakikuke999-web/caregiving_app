class PersonalSchedulesController < ApplicationController
  before_action :set_care_recipient, except: [:calendar_events, :calendar_events_all]
  before_action :set_personal_schedule, only: %i[edit update destroy]

  COLOR = "#4a3aa7".freeze

  def new
    @personal_schedule = @care_recipient.personal_schedules.new
    @personal_schedule.started_at = Time.zone.parse(params[:started_at]) if params[:started_at].present?
    authorize @personal_schedule
  end

  def create
    @personal_schedule = @care_recipient.personal_schedules.new(personal_schedule_params)
    @personal_schedule.created_by = current_user
    authorize @personal_schedule

    if @personal_schedule.save
      redirect_to calendar_care_recipient_path(@care_recipient), notice: "予定を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @personal_schedule
  end

  def update
    authorize @personal_schedule

    if @personal_schedule.update(personal_schedule_params)
      redirect_to calendar_care_recipient_path(@care_recipient), notice: "予定を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @personal_schedule
    @personal_schedule.destroy!
    redirect_to calendar_care_recipient_path(@care_recipient), notice: "予定を削除しました", status: :see_other
  end

  def calendar_events
    care_recipient = CareRecipient.find(params[:id])
    authorize care_recipient, :show?
    schedules = policy_scope(PersonalSchedule).where(care_recipient_id: care_recipient.id)
    render json: schedules.map { |schedule| event_json(schedule) }
  end

  def calendar_events_all
    schedules = policy_scope(PersonalSchedule).includes(:care_recipient)
    render json: schedules.map { |schedule| event_json(schedule, include_recipient_name: true) }
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_personal_schedule
    @personal_schedule = @care_recipient.personal_schedules.find(params[:id])
  end

  def personal_schedule_params
    params.require(:personal_schedule).permit(:title, :started_at, :ended_at, :notes)
  end

  def event_json(schedule, include_recipient_name: false)
    title = include_recipient_name ? "#{schedule.care_recipient.name}: #{schedule.title}（本人の予定）" : "#{schedule.title}（本人の予定）"

    {
      title: title,
      start: schedule.started_at,
      end: schedule.ended_at,
      color: COLOR,
      extendedProps: {
        kind: "personal_schedule",
        id: schedule.id,
        care_recipient_id: schedule.care_recipient_id,
        details: schedule.notes,
        care_recipient_name: schedule.care_recipient.name
      }
    }
  end
end
