class Api::SurvivorsController < ApplicationController
  # POST api.domain_name/survivor
  def create
    survivor = Survivor.new(survivor_params)
    inventory = params[:survivor][:inventory] || {}

    InventoryList.build_inventory(survivor, inventory)

    if survivor.save
      render json: survivor, status: :created
    else
      render json: {
        errors: survivor.errors}.to_json,
        status: :unprocessable_entity
    end
  end

  # PATCH/PUT api.domain_name/survivor/:id
  def update
    survivor = Survivor.find_by_id(params[:id])

    return render json: "null", status: :not_found unless survivor

    if survivor.update(location_params)
      render json: survivor, status: :ok
    else
      render json: {
        errors: survivor.errors}.to_json,
        status: :unprocessable_entity
    end
  end

  private
  def survivor_params
    permitted_params = params.require(:survivor).
      permit(:name, :age, :gender, :latitude, :longitude, inventory: {})
  end

  def location_params
    params.require(:survivor).permit([:latitude, :longitude])
  end
end
