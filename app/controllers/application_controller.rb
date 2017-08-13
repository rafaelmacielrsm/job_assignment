class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :check_json_api_headers
  before_action :set_json_api_header

  protected
  # Check if the request headers are correct
  def check_json_api_headers
    unless request.headers["Content-Type"] && request.headers["Content-Type"].
      include?("application/vnd.api+json")
        return render json: "", status: :unsupported_media_type
    end

    unless request.headers["Accept"] &&
      request.headers["Accept"].include?("application/vnd.api+json")
        return render json: "", status: :not_acceptable
    end
  end

  # set the response content-type to follow the json api v.1.0 specification
  def set_json_api_header
    response.set_header("Content-Type", "application/vnd.api+json")
  end
end
