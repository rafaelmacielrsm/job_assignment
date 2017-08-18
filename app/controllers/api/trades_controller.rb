class Api::TradesController < ApplicationController
  # POST api.domain_name/trade
  def create
    trading_offer = Trading.new(trade_params.to_h)
    if trading_offer.valid?
      survivor = Survivor.find(trading_offer.offer[:survivor_id])
      trading_offer.execute_trade!
      render json: survivor , status: :created
    else
      render json: {errors: trading_offer.errors}.to_json, status: :unprocessable_entity
    end
  end

  def trade_params
    params.require(:trade).permit(offer: {}, for: {})
  end
end
