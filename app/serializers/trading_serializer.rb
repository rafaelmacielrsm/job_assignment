class TradingSerializer < ActiveModel::Serializer
  attributes :survivor_id, :inventory

  def survivor_id
    object.offer[:survivor_id]
  end

  def inventory
    object.offer[:records].map {|e| [e.item_name, e.quantity]}.to_h
  end
end
