class CareDocumentsController < ApplicationController
  before_action :set_care_recipient
  before_action :set_care_document, only: %i[edit update destroy]

  def index
    authorize @care_recipient, :show?
    @care_documents = policy_scope(CareDocument).where(care_recipient_id: @care_recipient.id).order(issued_on: :desc)
  end

  def new
    @care_document = @care_recipient.care_documents.new
    authorize @care_document
  end

  def create
    @care_document = @care_recipient.care_documents.new(care_document_params)
    @care_document.uploaded_by = current_user
    authorize @care_document

    if @care_document.save
      redirect_to care_recipient_care_documents_path(@care_recipient), notice: "書類を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @care_document
  end

  def update
    authorize @care_document

    if @care_document.update(care_document_params)
      redirect_to care_recipient_care_documents_path(@care_recipient), notice: "書類を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @care_document
    @care_document.destroy!
    redirect_to care_recipient_care_documents_path(@care_recipient), notice: "書類を削除しました", status: :see_other
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def set_care_document
    @care_document = @care_recipient.care_documents.find(params[:id])
  end

  def care_document_params
    params.require(:care_document).permit(
      :document_type, :title, :issuing_organization, :issued_on, :valid_from, :valid_until, :note, :file
    )
  end
end
