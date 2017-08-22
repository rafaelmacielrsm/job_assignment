class Api::ReportsController < ApplicationController
  # GET api.<domain_name>/reports
  def index
    render json: {
      data: "null",
      links: [
        infected_api_reports_url,
        non_infected_api_reports_url,
        inventories_overview_api_reports_url,
        resources_lost_api_reports_url]
    }.to_json, status: :ok
  end

  # GET api.<domain_name>/reports/infected
  def infected
    total = Survivor.count.to_f
    if total == 0
      render json: {
        errors: { infected: I18n.t('report.failure.zero_survivor')}}.to_json
    else
      render json: Report.data_json( I18n.t('report.success.infected'),
        Survivor.infected_survivors.count / total ), status: :ok
    end
  end

  def non_infected
    total = Survivor.count.to_f
    if total == 0
      render json: {
        errors: { non_infected: I18n.t('report.failure.zero_survivor')}}.to_json
    else
      render json: Report.data_json( I18n.t('report.success.non_infected'),
        Survivor.non_infected_survivors.count / total ), status: :ok
    end
  end

  def inventories_overview
    items_average = Item.items_average_for_non_infected_survivors
    render json:
      Report.data_json(I18n.t('report.success.inventories_overview'),
        items_average), status: :ok
  end

  def resources_lost
    points_lost = Item.points_lost_due_to_infection

    render json:
      Report.data_json(I18n.t('report.success.resources_lost'), points_lost),
      status: :ok
  end
end
