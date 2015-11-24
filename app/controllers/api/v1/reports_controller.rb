module Api
  module V1
    class ReportsController < Api::BaseController
      before_action :load_report, only: [:show]

      # GET /api/v1/reports/ with ApiToken in headers
      def index
        @reports = Report.for_user current_user
        render json: @reports, each_serializer: ReportSerializer
      end

      # GET /api/v1/reports/:id with ApiToken in headers
      def show
        render json: @report, serializer: ReportSerializer
      end

      private

      # TODO: To move to concern
      def load_report
        # TODO: Adding CanCanCan
        @report = Report.for_user(current_user).find params[:id]
      end
    end
  end
end
