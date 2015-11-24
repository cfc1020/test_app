class ReportsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :load_report, only: [:show, :add_comment]

  def index
    @reports = Report.for_user current_user
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build report_params

    # TODO: Add responders gem
    if @report.save
      redirect_to @report
    else
      render :new
    end
  end

  def add_comment
    if @report.update_attributes(comment_params)
      redirect_to @report
    else
      render :show
    end
  end

  private

  def report_params
    params.require(:report).permit(:campaign_id)
  end

  def comment_params
    params.require(:report).permit(:comment)
  end

  def load_report
    # TODO: Add CanCanCan
    @report = Report.for_user(current_user).find params[:id]
  end
end
