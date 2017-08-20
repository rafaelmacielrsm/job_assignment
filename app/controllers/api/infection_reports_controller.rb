class Api::InfectionReportsController < ApplicationController
  # POST api.<domain_name>/survivor/:survivor_id/infection_report
  def create
    report = InfectionReport.new(report_params)
    if report.save
      render json: report, status: :created
    else
      render json: {errors: report.errors}.to_json,
        status: :unprocessable_entity
    end

  end

  private
  def report_params
    params.require(:infection_report).permit([:infected_id]).merge(
      survivor_id: params[:survivor_id])
  end
end
