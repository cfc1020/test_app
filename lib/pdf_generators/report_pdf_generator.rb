require 'render_anywhere'

module PdfGenerators
  class ReportPdfGenerator
    include RenderAnywhere

    PARTIAL_NAME = 'reports/report_template'

    def initialize(report_template)
      @report_template = report_template
    end

    def generate!
      save_pdf_report_to_file
    end

    def pdf_report
      @pdf_report ||= build_pdf_report
    end

    private

    def build_pdf_report
      set_render_anywhere_helpers(ReportsHelper)

      html_string = render(
        pdf: @report_template.report.pdf_report_name,
        partial: PARTIAL_NAME,
        locals: { report_template: @report_template },
        layout: 'wicked_pdf.pdf'
      )

      WickedPdf.new.pdf_from_string html_string
    end

    def save_pdf_report_to_file
      save_path = @report_template.report.path_to_pdf_report

      File.open(save_path, 'wb') do |file|
        file << pdf_report
      end
    end
  end
end
