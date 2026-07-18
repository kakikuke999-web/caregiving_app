class CarePlansController < ApplicationController
  before_action :set_care_recipient
  before_action :set_care_plan, only: %i[show edit update destroy]

  def index
    authorize CarePlan.new(care_recipient: @care_recipient)
    @care_plans = policy_scope(@care_recipient.care_plans)
  end

  def show
    authorize @care_plan
    @weekly_rows = weekly_schedule_rows
  end

  def new
    @care_plan = @care_recipient.care_plans.new(created_on: Date.current)
    @care_plan.care_plan_goals.build.care_plan_services.build
    authorize @care_plan
  end

  def create
    @care_plan = @care_recipient.care_plans.new(care_plan_params)
    @care_plan.created_by = current_user
    authorize @care_plan

    if @care_plan.save
      redirect_to care_recipient_care_plan_path(@care_recipient, @care_plan), notice: "居宅サービス計画書を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @care_plan
    @care_plan.care_plan_goals.build.care_plan_services.build if @care_plan.care_plan_goals.empty?
  end

  def update
    authorize @care_plan

    if @care_plan.update(care_plan_params)
      redirect_to care_recipient_care_plan_path(@care_recipient, @care_plan), notice: "居宅サービス計画書を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @care_plan
    @care_plan.destroy!
    redirect_to care_recipient_care_plans_path(@care_recipient), notice: "居宅サービス計画書を削除しました", status: :see_other
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_care_plan
    @care_plan = @care_recipient.care_plans.find(params[:id])
  end

  def care_plan_params
    params.require(:care_plan).permit(
      :created_on, :office_name, :policy_summary, :family_intention,
      :certification_committee_opinion, :assistance_reason,
      care_plan_goals_attributes: [
        :id, :issue, :long_term_goal, :long_term_goal_period,
        :short_term_goal, :short_term_goal_period, :position, :_destroy,
        care_plan_services_attributes: [:id, :content, :category, :provider, :frequency, :period, :position, :_destroy]
      ]
    )
  end

  # 第3表（週間サービス計画表）は、既に登録されている「定期予定」からそのまま組み立てる。
  # 二重入力を避けるための設計判断（サービス利用票と同じ考え方）。
  def weekly_schedule_rows
    @care_recipient.recurring_schedules.active.includes(:visit_type).order(:day_of_week, :start_time).map do |schedule|
      {
        day_of_week: schedule.day_of_week,
        day_name: schedule.day_name,
        time_range: schedule.time_range_label,
        visit_type_name: schedule.visit_type.name,
        assignee: schedule.assignee_label
      }
    end
  end
end
