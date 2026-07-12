class DailyReportImportsController < ApplicationController
  before_action :set_care_recipient
  before_action :authorize_import

  def new; end

  def create
    result = DailyReportBulkImport.call(care_recipient: @care_recipient, json: params[:json])
    @result = result
    if result.errors.empty?
      flash.now[:notice] = "#{result.created}件登録しました（#{result.skipped}件は既存のためスキップ）"
    else
      flash.now[:alert] = "#{result.created}件登録、#{result.skipped}件スキップ、#{result.errors.size}件エラー"
    end
    render :new
  rescue JSON::ParserError => e
    @result = nil
    flash.now[:alert] = "JSONの解析に失敗しました: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  private

  def set_care_recipient
    @care_recipient = CareRecipient.find(params[:care_recipient_id])
  end

  def authorize_import
    authorize :daily_report_import, :create?, policy_class: DailyReportImportPolicy
  end
end
