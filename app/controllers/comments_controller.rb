class CommentsController < ApplicationController
  before_action :set_visit_report

  def create
    @comment = Comment.new(comment_params.merge(visit_report: @visit_report, user: current_user))
    authorize @comment

    if @comment.save
      redirect_to @visit_report, notice: "コメントを投稿しました"
    else
      render "visit_reports/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @visit_report.comments.find(params[:id])
    authorize @comment
    @comment.destroy!
    redirect_to @visit_report, notice: "コメントを削除しました", status: :see_other
  end

  private

  def set_visit_report
    @visit_report = VisitReport.find(params[:visit_report_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
