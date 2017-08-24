class Api::InfectionReportsController < ApplicationController
  # POST api.<domain_name>/survivors/:survivor_id/infection_reports
  def create
    survivor = Survivor.find_by_id(params[:survivor_id])

    return render json: "null", status: :not_found unless survivor

    report = survivor.submitted_reports.build(report_params)

    if report.save
      render json: report, status: :created
    else
      render json: {errors: report.errors}.to_json,
        status: :unprocessable_entity
    end

  end

  private
  def report_params
    params.require(:infection_report).permit([:infected_id])
  end
end
