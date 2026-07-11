class VisitTypesController < ApplicationController
  before_action :set_visit_type, only: %i[edit update destroy]

  def index
    authorize VisitType
    @visit_types = policy_scope(VisitType).order(:name)
  end

  def new
    @visit_type = VisitType.new
    authorize @visit_type
  end

  def create
    @visit_type = VisitType.new(visit_type_params)
    authorize @visit_type

    if @visit_type.save
      redirect_to visit_types_path, notice: "訪問タイプを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @visit_type
  end

  def update
    authorize @visit_type

    if @visit_type.update(visit_type_params)
      redirect_to visit_types_path, notice: "訪問タイプを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @visit_type
    if @visit_type.destroy
      redirect_to visit_types_path, notice: "訪問タイプを削除しました", status: :see_other
    else
      redirect_to visit_types_path, alert: @visit_type.errors.full_messages.to_sentence, status: :see_other
    end
  end

  private

  def set_visit_type
    @visit_type = VisitType.find(params[:id])
  end

  def visit_type_params
    params.require(:visit_type).permit(:name)
  end
end
