class VitalsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_vital, only: %i[edit update destroy]

  def index
    authorize @care_recipient, :show?
    @vitals = @care_recipient.vitals.includes(:recorded_by).order(recorded_at: :desc)
  end

  def new
    @vital = @care_recipient.vitals.new(type: params[:type])
    authorize @vital
    @last_values_by_type = last_values_by_type
  end

  def create
    @vital = @care_recipient.vitals.new(vital_params)
    @vital.recorded_by = current_user
    authorize @vital

    if @vital.save
      redirect_to care_recipient_vitals_path(@care_recipient), notice: "バイタルを記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @vital
  end

  def update
    authorize @vital

    if @vital.update(vital_params)
      redirect_to care_recipient_vitals_path(@care_recipient), notice: "バイタルを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @vital
    @vital.destroy!
    redirect_to care_recipient_vitals_path(@care_recipient), notice: "バイタルを削除しました"
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_vital
    @vital = @care_recipient.vitals.find(params[:id])
  end

  def vital_params
    params.require(:vital).permit(:type, :value, :systolic, :diastolic, :recorded_at, :note)
  end

  # 各項目ごとの直近の記録値（「前回の値をコピー」ボタン用）
  def last_values_by_type
    Vital::TYPES.index_with do |type|
      last = @care_recipient.vitals.where(type: type).order(recorded_at: :desc).first
      next nil unless last

      { value: last.value, systolic: last.systolic, diastolic: last.diastolic }
    end
  end
end
