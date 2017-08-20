class Api::TradesController < ApplicationController
  # POST api.<domain_name>/survivor/:survivor_id/trade
  def create
    trading_offer = Trading.new(trade_params.to_h)
    if trading_offer.valid?
      trading_offer.execute_trade!
      survivor = Survivor.find(trading_offer.offer[:survivor_id])
      render json: survivor , status: :created
    else
      render json: {errors: trading_offer.errors}.to_json, status: :unprocessable_entity
    end
  end

  def trade_params
    trading_params = params.require(:trade).permit(offer: {}, for: {})
    trading_params[:offer].merge!(survivor_id: params[:survivor_id])
    trading_params
  end
end
