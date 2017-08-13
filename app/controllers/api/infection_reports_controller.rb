class Api::InfectionReportsController < ApplicationController
  # POST api.domain_name/infection_report
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
    params.require(:infection_report).permit([:survivor_id, :infected_id])
  end
end
